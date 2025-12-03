Class {
	#name : 'MSRSource',
	#superclass : 'Object',
	#instVars : [
		'type',
		'id',
		'url',
		'author',
		'points',
		'attachedUrl',
		'title',
		'storyText',
		'createdAt',
		'commentsTotalCount',
		'chatgptSharings',
		'analyzer'
	],
	#category : 'ProyectoMSRGrupo3-model',
	#package : 'ProyectoMSRGrupo3',
	#tag : 'model'
}

{ #category : 'as yet unclassified' }
MSRSource >> addChatGPTSharing: aSharing [
    chatgptSharings add: aSharing.
]

{ #category : 'as yet unclassified' }
MSRSource >> analyzer [
    ^ analyzer
]

{ #category : 'as yet unclassified' }
MSRSource >> analyzer: anObject [
    analyzer := anObject
]

{ #category : 'as yet unclassified' }
MSRSource >> attachedUrl: aUrl [
    attachedUrl := aUrl.
]

{ #category : 'as yet unclassified' }
MSRSource >> author: aName [
    author := aName.
]

{ #category : 'as yet unclassified' }
MSRSource >> chatgptSharings [
    ^ chatgptSharings
]

{ #category : 'as yet unclassified' }
MSRSource >> chatgptSharings: aCollection [
    chatgptSharings := aCollection

]

{ #category : 'as yet unclassified' }
MSRSource >> coloresSection [
    <gtInspectorPresentation>
    ^ BlElement new
        layout: BlLinearLayout vertical;
        addChild: (BlTextElement new text: 'Significado de los colores'; yourself);
        addChild: (self tablaColores);
        yourself.

]

{ #category : 'as yet unclassified' }
MSRSource >> commentsTotalCount: aNumber [
    commentsTotalCount := aNumber.
]

{ #category : 'as yet unclassified' }
MSRSource >> createdAt [
    ^ createdAt
]

{ #category : 'as yet unclassified' }
MSRSource >> createdAt: aDateTime [
    createdAt := aDateTime.
]

{ #category : 'as yet unclassified' }
MSRSource >> filaColor: nombre color: unColor [
    ^ BlElement new
        layout: BlLinearLayout horizontal;
        addChild: (BlTextElement new text: nombre asText);
        addChild: (BlElement new
            background: unColor;
            size: 20@20;
            margin: (BlInsets left: 10);
            yourself);
        margin: (BlInsets all: 5);
        yourself.

]

{ #category : 'as yet unclassified' }
MSRSource >> filaColorSimple: nombre color: unColor [
    | row label colorBox |

    row := BlElement new.
    row layout: (BlLinearLayout horizontal).
    row margin: (BlInsets all: 6).
    row size: 320 @ 30.

    "Etiqueta de texto"
    label := BlTextElement new.
    label text: nombre.
    label margin: (BlInsets all: 4).
    label size: 220 @ 22.
    row addChild: label.

    "Cuadro de color"
    colorBox := BlElement new.
    colorBox background: unColor.
    colorBox size: 20 @ 20.
    colorBox margin: (BlInsets all: 4).
    row addChild: colorBox.

    ^ row

]

{ #category : 'as yet unclassified' }
MSRSource >> gtViewConversaciones: aView [
    <gtView>

    | localAnalyzer  blockSize maxWords unitPx minPx |
    localAnalyzer := self analyzer.

    ^ aView explicit
        title: 'Visualización de Conversaciones';
        stencil: [
            | container child colorMapping topLangs topColors color lang |
            
            "---- CONFIGURACIÓN ----"
            blockSize := 25.
            maxWords := 300.
            unitPx := 12.
            minPx := 10.

            container := BlElement new.
            container size: 750 @ 750.
            container layout: BlFlowLayout new.

            "---- OBTENER TOP 5 LENGUAJES ----"
            topLangs := (localAnalyzer topFiveLanguages keys) asArray.

            "Paleta en HEX (7 colores total)"
            topColors := {
                (Color fromHexString: '#D64545').   "Azul"
                (Color fromHexString: '#3A66DB').   "Verde"
                (Color fromHexString: '#E6C229').   "Naranjo pastel"
                (Color fromHexString: '#3BB273').   "Rosa suave"
                (Color fromHexString: '#7A4CC0')    "Violeta"
            }.

            colorMapping := Dictionary new.
            1 to: topLangs size do: [:i |
                colorMapping at: (topLangs at: i) put: (topColors at: i)
            ].

            colorMapping at: 'other' put: (Color fromHexString: '#1A1A1A'). "Otros lenguajes"
            colorMapping at: 'noCode' put: (Color fromHexString: '#BDBDBD'). "Sin código"

            "---- RECORRER CONVERSACIONES ----"
            self chatgptSharings do: [:sharing |
                sharing conversations do: [:conv |

                    | promptText answerText promptCount answerCount
                      promptBucket answerBucket heightPx widthPx |

                    promptText := conv prompt ifNil: [''].
                    answerText := conv answer ifNil: [''].

                    promptCount := (promptText findTokens: ' ') size.
                    answerCount := (answerText findTokens: ' ') size.

                    promptCount := promptCount min: maxWords.
                    answerCount := answerCount min: maxWords.

                    promptBucket := (promptCount = 0)
                        ifTrue: [1]
                        ifFalse: [(promptCount - 1 // blockSize) + 1].

                    answerBucket := (answerCount = 0)
                        ifTrue: [1]
                        ifFalse: [(answerCount - 1 // blockSize) + 1].

                    heightPx := (promptBucket * unitPx) max: minPx.
                    widthPx := (answerBucket * unitPx) max: minPx.

                    child := BlElement new.
                    child size: widthPx asInteger @ heightPx asInteger.

                    conv listOfCode isEmpty
                        ifTrue: [ 
                            color := (colorMapping at: 'noCode')
                        ]
                        ifFalse: [
                            lang := conv listOfCode first type.
                            color := (colorMapping at: lang ifAbsent: [ colorMapping at: 'other'])
                        ].

                    child background: color.
                    child margin: (BlInsets all: 5).

                    container addChild: child.
                ].
            ].

            container
        ].

]

{ #category : 'as yet unclassified' }
MSRSource >> id: anId [
    id := anId.
]

{ #category : 'as yet unclassified' }
MSRSource >> initialize [
    super initialize.
    chatgptSharings := OrderedCollection new.
]

{ #category : 'as yet unclassified' }
MSRSource >> legendRow: aLabel color: aColor [
    | row colorBox textEl |
    row := BlElement new.
    row layout: BlLinearLayout horizontal.

    "Cuadro de color"
    colorBox := BlElement new.
    colorBox size: 20@20.
    colorBox background: aColor.
    colorBox margin: (BlInsets left: 0 top: 4 right: 8 bottom: 4).

    "Etiqueta"
    textEl := BlTextElement new.
    textEl text: aLabel.
    textEl margin: (BlInsets top: 4 left: 0 right: 0 bottom: 4).

    row addChild: colorBox.
    row addChild: textEl.

    ^ row

]

{ #category : 'as yet unclassified' }
MSRSource >> points: aNumber [
    points := aNumber.
]

{ #category : 'as yet unclassified' }
MSRSource >> storyText: aString [
    storyText := aString.
]

{ #category : 'as yet unclassified' }
MSRSource >> tablaColores [
    ^ BlElement new
        layout: BlLinearLayout vertical;
        addChild: (self filaColor: 'Rojo' color: Color red);
        addChild: (self filaColor: 'Azul' color: Color blue);
        addChild: (self filaColor: 'Verde' color: Color green);
        yourself.

]

{ #category : 'as yet unclassified' }
MSRSource >> tablaColoresSimple [
    | cont |
    cont := BlElement new.
    cont layout: BlLinearLayout vertical.
    cont padding: (BlInsets all: 10).
    cont size: 350 @ 160.

    cont addChild: (self filaColorSimple: 'Rojo' color: Color red).
    cont addChild: (self filaColorSimple: 'Azul' color: Color blue).
    cont addChild: (self filaColorSimple: 'Verde' color: Color green).

    ^ cont

]

{ #category : 'as yet unclassified' }
MSRSource >> title: aString [
    title := aString.
]

{ #category : 'as yet unclassified' }
MSRSource >> type: aType [
    type := aType.
]

{ #category : 'as yet unclassified' }
MSRSource >> url: aUrl [
    url := aUrl.
]
