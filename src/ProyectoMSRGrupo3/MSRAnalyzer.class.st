Class {
	#name : 'MSRAnalyzer',
	#superclass : 'Object',
	#instVars : [
		'sources'
	],
	#category : 'ProyectoMSRGrupo3-model',
	#package : 'ProyectoMSRGrupo3',
	#tag : 'model'
}

{ #category : 'as yet unclassified' }
MSRAnalyzer >> allConversations [
    | all |
    all := OrderedCollection new.

    sources do: [:src |
        src chatgptSharings do: [:sharing |
            all addAll: sharing conversations.
        ].
    ].

    ^ all

]

{ #category : 'as yet unclassified' }
MSRAnalyzer >> categoriasPalabrasClave [
    ^ Dictionary newFrom: {
        'Debugging and Bugs' -> #('bug' 'error' 'exception' 'crash' 'fail' 'fix' 'issue' 'fault' 'defect' 'debug' 'panic' 'traceback' 'stack trace' 'problem' 'breakpoint').
        'Syntax Errors' -> #('syntax error' 'compile error' 'parse error' 'invalid syntax' 'typo' 'missing semicolon' 'unexpected token' 'parse failure').
        'Refactoring and Optimization' -> #('refactor' 'optimize' 'performance' 'clean code' 'improve efficiency' 'reduce complexity' 'best practice' 'memory usage' 'speed up').
        'Testing' -> #('test' 'unit test' 'integration test' 'mock' 'assertion' 'test case' 'coverage' 'test suite' 'regression' 'validation').
        'Explanation and Documentation' -> #('explain' 'document' 'comment' 'tutorial' 'guide' 'instruction' 'help' 'manual' 'description' 'note' 'example' 'readme' 'javadoc' 'uml').
        'Design and Implementation' -> #('design' 'architecture' 'pattern' 'implement' 'feature' 'module' 'component' 'framework' 'interface' 'workflow' 'pipeline' 'mvc' 'singleton' 'microservices').
        'Code Review' -> #('review' 'suggest' 'improve' 'best practice' 'code style' 'refinement' 'feedback' 'analysis' 'critique').
        'Error Handling' -> #('error handling' 'exception handling' 'try catch' 'failover' 'rollback' 'transaction management').
        'Security' -> #('secure' 'vulnerability' 'attack' 'threat' 'protection' 'authentication' 'authorization' 'safety' 'encryption' 'csrf' 'xss' 'sql injection').
        'Dependencies and Tools' -> #('dependency' 'version conflict' 'build error' 'library' 'tool' 'package' 'plugin' 'integration' 'environment' 'configuration' 'docker' 'maven' 'gradle').
        'Performance and Scalability' -> #('bottleneck' 'slow' 'scale' 'memory leak' 'throughput' 'latency' 'resource' 'load balancing' 'parallel' 'concurrency' 'threading' 'caching').
        'Education and Training' -> #('training plan' 'lesson plan' 'teaching' 'learning' 'curriculum' 'educational' 'student' 'skill building' 'tutorial' 'guide' 'objectives' 'workshop' 'class' 'coding bootcamp').
        'General Technical Queries' -> #('information' 'explain' 'description' 'author' 'story' 'data' 'conclusion' 'analysis' 'estimate' 'calculation' 'note' 'advice' 'question' 'query').
        'Other Technical Topics' -> #('api' 'rest' 'graphql' 'http' 'https' 'json' 'xml' 'serialization' 'deserialization' 'tcp' 'udp' 'network' 'protocol' 'cloud' 'aws' 'azure' 'gcp').
    }.

]

{ #category : 'as yet unclassified' }
MSRAnalyzer >> categoriasPorConversacion [
    | dict result |
    dict := self categoriasPalabrasClave.
    result := Dictionary new.

    self allConversations do: [:conv |
        | prompt maxCount maxCat |
        prompt := conv prompt asLowercase.
        maxCount := 0.
        maxCat := 'Sin categoría'.

        dict keysAndValuesDo: [:categoria :palabras |
            | count |
            count := palabras count: [:p | prompt includesSubstring: p ].
            count > maxCount ifTrue: [
                maxCount := count.
                maxCat := categoria.
            ].
        ].

        (result at: maxCat ifAbsentPut: [ OrderedCollection new ])
            add: conv.
    ].

    ^ result

]

{ #category : 'as yet unclassified' }
MSRAnalyzer >> conversacionesPorFranja [
    "Devuelve un Dictionary con las franjas horarias: 'Mañana', 'Tarde', 'Noche'.
    Cada franja contiene todos los MSRChatGPTSharing correspondientes a los sources en esa franja horaria."

    | franjas |
    franjas := Dictionary new.
    franjas at: 'Mañana' put: OrderedCollection new.
    franjas at: 'Tarde' put: OrderedCollection new.
    franjas at: 'Noche' put: OrderedCollection new.

    sources do: [:src |
        | fechaString fecha hour franja |

        "Tomamos la fecha del source y aseguramos que sea String"
        fechaString := (src createdAt) asString.
        "Adaptar formato ISO a algo que DateAndTime pueda parsear"
        fechaString := fechaString copyReplaceAll: 'T' with: ' '.
        fechaString := fechaString copyReplaceAll: 'Z' with: ''.

        "Intentar parsear la fecha, ignorando errores"
        [ fecha := DateAndTime fromString: fechaString ]
            on: Error do: [:e |
                Transcript show: 'Fecha inválida: ', fechaString; cr.
                fecha := nil.
            ].

        fecha ifNotNil: [
            hour := fecha hour.

            "Determinar franja horaria"
            franja := (hour between: 6 and: 12)
                ifTrue: ['Mañana']
                ifFalse: [
                    (hour between: 13 and: 18)
                        ifTrue: ['Tarde']
                        ifFalse: ['Noche']
                ].

            "Agregar todos los ChatGPTSharings del source a la franja correspondiente"
            (franjas at: franja) addAll: src chatgptSharings.
        ].
    ].

    ^ franjas

]

{ #category : 'as yet unclassified' }
MSRAnalyzer >> conversationsWithCode [
    ^ self allConversations select: [:conv |
        conv listOfCode notEmpty
    ].

]

{ #category : 'as yet unclassified' }
MSRAnalyzer >> sources [
    ^ sources
]

{ #category : 'as yet unclassified' }
MSRAnalyzer >> sources: aCollection [
    sources := aCollection
]

{ #category : 'as yet unclassified' }
MSRAnalyzer >> topFiveLanguages [
    "Devuelve un Dictionary con los 5 lenguajes más usados.
    Cada clave es el nombre del lenguaje, y el valor es la colección de MSRConversation que contienen código de ese lenguaje."

    | dict sorted firstFive topDict |

    dict := Dictionary new.

    "Llenar dict con lenguaje -> conversaciones"
    self conversationsWithCode do: [:conv |
        conv listOfCode do: [:snippet |
            | lang list |
            lang := snippet type.
            list := dict at: lang ifAbsentPut: [ OrderedCollection new ].
            list add: conv.
        ].
    ].

    "Ordenar por cantidad de conversaciones por lenguaje"
    sorted := dict associations
        sorted: [:a :b | a value size > b value size ].

    "Tomar los primeros 5 lenguajes"
    firstFive := sorted copyFrom: 1 to: (sorted size min: 5).

    "Crear un Dictionary final"
    topDict := Dictionary new.
    firstFive do: [:assoc |
        topDict at: assoc key put: assoc value.
    ].

    ^ topDict

]
