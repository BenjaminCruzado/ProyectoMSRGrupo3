Class {
	#name : 'AnalizadorConversaciones',
	#superclass : 'Object',
	#instVars : [
		'jsonData',
		'sources',
		'allConversations',
		'conversationsWithCode',
		'dictLenguajesConvs',
		'navigationSelection',
		'navigationLevel',
		'nivel'
	],
	#category : 'ProyectoMSRGrupo3-model',
	#package : 'ProyectoMSRGrupo3',
	#tag : 'model'
}

{ #category : 'accessing' }
AnalizadorConversaciones >> categoriasPalabrasClave [
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

{ #category : 'accessing' }
AnalizadorConversaciones >> clasificarConversacionesPorCategoria [
    | dictCategoriasConvs dictCategorias promptText maxCount maxCategory convsForCat |
    
    dictCategorias := self categoriasPalabrasClave.
    dictCategoriasConvs := Dictionary new.

    sources do: [:source |
        | chatgptSharings conversations |
        chatgptSharings := (source isKindOf: Dictionary)
            ifTrue: [source at: 'ChatgptSharing' ifAbsent: [#()]]
            ifFalse: [#()].
        chatgptSharings do: [:chatgptSharing |
            conversations := (chatgptSharing isKindOf: Dictionary)
                ifTrue: [chatgptSharing at: 'Conversations' ifAbsent: [#()]]
                ifFalse: [#()].
            conversations do: [:conv |
                promptText := (conv isKindOf: Dictionary) & (conv includesKey: 'Prompt')
                    ifTrue: [(conv at: 'Prompt') asLowercase]
                    ifFalse: [''].
                maxCount := 0.
                maxCategory := ''.
                dictCategorias keysAndValuesDo: [:cat :palabras |
                    | count |
                    count := 0.
                    palabras do: [:palabra |
                        (promptText includesSubstring: palabra) ifTrue: [count := count + 1].
                    ].
                    count > maxCount ifTrue: [
                        maxCount := count.
                        maxCategory := cat.
                    ].
                ].
                (maxCategory isEmpty or: [maxCount = 0])
                    ifTrue: [maxCategory := 'Sin categoría'].
                convsForCat := dictCategoriasConvs at: maxCategory ifAbsentPut: [OrderedCollection new].
                (convsForCat includes: conv) ifFalse: [convsForCat add: conv].
            ].
        ].
    ].
    ^ dictCategoriasConvs

]

{ #category : 'accessing' }
AnalizadorConversaciones >> conteoPorFranjaHoraria [
    | conteos |
    conteos := Dictionary new.
    (self conversacionesPorFranjaHoraria) keysAndValuesDo: [:franja :convs |
        conteos at: franja put: convs size.
    ].
    ^ conteos
]

{ #category : 'accessing' }
AnalizadorConversaciones >> conversacionesPorFranjaHoraria [
    | franjaConversations |
    franjaConversations := Dictionary new.
    franjaConversations at: 'Mañana' put: OrderedCollection new.
    franjaConversations at: 'Tarde' put: OrderedCollection new.
    franjaConversations at: 'Noche' put: OrderedCollection new.

    sources do: [:source |
        (source isKindOf: Dictionary) ifTrue: [
            (source at: 'ChatgptSharing' ifAbsent: [#()]) do: [:chatgptSharing |
                | date dateHour franja |
                date := (chatgptSharing at: 'DateOfAccess' ifAbsent: ['']) asString.
                (date isEmpty) ifFalse: [
                    date := DateAndTime fromString: date.
                    dateHour := date hour.
                    franja := (dateHour >= 6 and: [dateHour <= 12]) 
                        ifTrue: ['Mañana']
                        ifFalse: [(dateHour >= 13 and: [dateHour <= 18]) 
                            ifTrue: ['Tarde'] 
                            ifFalse: ['Noche']].
                    (franjaConversations at: franja) add: chatgptSharing.
                ].
            ].
        ].
    ].
    ^ franjaConversations
]

{ #category : 'accessing' }
AnalizadorConversaciones >> extractAllConversations [
    allConversations := OrderedCollection new.
    sources do: [:source |
        | chatgptSharings conversations |
        chatgptSharings := (source isKindOf: Dictionary)
            ifTrue: [source at: 'ChatgptSharing' ifAbsent: [#()]]
            ifFalse: [#()].
        chatgptSharings do: [:chatgptSharing |
            conversations := (chatgptSharing isKindOf: Dictionary)
                ifTrue: [chatgptSharing at: 'Conversations' ifAbsent: [#()]]
                ifFalse: [#()].
            allConversations addAll: conversations.
        ]].
    ^ allConversations

]

{ #category : 'accessing' }
AnalizadorConversaciones >> extractConversationsWithCode [
    conversationsWithCode := OrderedCollection new.
    sources do: [:source |
        | chatgptSharings conversations |
        chatgptSharings := (source isKindOf: Dictionary)
            ifTrue: [source at: 'ChatgptSharing' ifAbsent: [#()]]
            ifFalse: [#()].
        chatgptSharings do: [:chatgptSharing |
            conversations := (chatgptSharing isKindOf: Dictionary)
                ifTrue: [chatgptSharing at: 'Conversations' ifAbsent: [#()]]
                ifFalse: [#()].
            conversations do: [:conv |
                | listOfCode |
                listOfCode := (conv isKindOf: Dictionary)
                    ifTrue: [conv at: 'ListOfCode' ifAbsent: [#()]]
                    ifFalse: [#()].
                (listOfCode detect: [:codeItem |
                    (codeItem isKindOf: Dictionary) and: [
                        (codeItem at: 'Content' ifAbsent: [nil]) notNil
                    ] ] ifNone: [nil])
                ifNotNil: [conversationsWithCode add: conv].
            ]].
        ].
    ^ conversationsWithCode

]

{ #category : 'accessing' }
AnalizadorConversaciones >> loadFromFile: aFileName [
    | jsonString dictionary |
    jsonString := aFileName asFileReference readStream contents.
    dictionary := STONJSON fromString: jsonString.
    jsonData := dictionary.
    sources := (dictionary includesKey: 'Sources')
        ifTrue: [dictionary at: 'Sources']
        ifFalse: [#()].
    ^ self

]

{ #category : 'accessing' }
AnalizadorConversaciones >> sources [
	^ sources
]

{ #category : 'accessing' }
AnalizadorConversaciones >> sources: anObject [
	sources := anObject
]

{ #category : 'accessing' }
AnalizadorConversaciones >> topFiveLanguagesWithConversations [
| sorted top5 top5Dict |
    dictLenguajesConvs := Dictionary new.
   
    sources do: [:source |
        | chatgptSharings conversations |
        chatgptSharings := (source isKindOf: Dictionary)
            ifTrue: [source at: 'ChatgptSharing' ifAbsent: [#()]]
            ifFalse: [#()].
        chatgptSharings do: [:chatgptSharing |
            conversations := (chatgptSharing isKindOf: Dictionary)
                ifTrue: [chatgptSharing at: 'Conversations' ifAbsent: [#()]]
                ifFalse: [#()].
            conversations do: [:conv |
                | listOfCode |
                listOfCode := (conv isKindOf: Dictionary)
                    ifTrue: [conv at: 'ListOfCode' ifAbsent: [#()]]
                    ifFalse: [#()].
                listOfCode do: [:codeItem |
                    (codeItem isKindOf: Dictionary) ifTrue: [
                        | content rawType typeCode convsForLang |
                        content := codeItem at: 'Content' ifAbsent: [nil].
                        content ifNotNil: [
                            rawType := codeItem at: 'Type' ifAbsent: [nil].
                            typeCode := nil.
                            rawType ifNotNil: [
                                typeCode := (rawType isKindOf: Array)
                                    ifTrue: [rawType first]
                                    ifFalse: [rawType].
                            ].
                            typeCode ifNil: [typeCode := 'desconocido'].
                            convsForLang := dictLenguajesConvs at: typeCode ifAbsentPut: [OrderedCollection new].
                            (convsForLang includes: conv) ifFalse: [convsForLang add: conv].
                        ].
                    ].
                ].
            ].
        ].
    ].
    
    sorted := dictLenguajesConvs
        associations
        sorted: [:a :b | (a value size) > (b value size)].
    top5 := sorted first: (sorted size min: 5).
    top5Dict := Dictionary new.
    top5 do: [:assoc | top5Dict at: assoc key put: assoc value].
    ^ top5Dict

]
