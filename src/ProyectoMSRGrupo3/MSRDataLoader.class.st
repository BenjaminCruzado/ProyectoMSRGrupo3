Class {
	#name : 'MSRDataLoader',
	#superclass : 'Object',
	#instVars : [
		'sources'
	],
	#category : 'ProyectoMSRGrupo3-model',
	#package : 'ProyectoMSRGrupo3',
	#tag : 'model'
}

{ #category : 'as yet unclassified' }
MSRDataLoader >> initialize [
    super initialize.
    sources := OrderedCollection new.
]

{ #category : 'as yet unclassified' }
MSRDataLoader >> loadFromFile: fileName [
    | jsonString json |
    jsonString := (FileSystem workingDirectory / fileName) contents.
    json := STON fromString: jsonString.
    self loadFromJsonArray: (json at: 'Sources').

]

{ #category : 'as yet unclassified' }
MSRDataLoader >> loadFromJsonArray: jsonArray [
    "jsonArray es una colección con cada objeto del dataset MSR"
    sources := jsonArray collect: [:dict | self parseSource: dict ].
]

{ #category : 'as yet unclassified' }
MSRDataLoader >> parseCodeSnippet: dict [
    | snippet |

    snippet := MSRCodeSnippet new.
    snippet replaceString: (dict at: 'ReplaceString' ifAbsent: [ '' ]).
    snippet type: (dict at: 'Type' ifAbsent: [ '' ]).
    snippet content: (dict at: 'Content' ifAbsent: [ '' ]).
    ^ snippet

]

{ #category : 'as yet unclassified' }
MSRDataLoader >> parseConversation: dict [
    | conv |

    conv := MSRConversation new.
    conv prompt: (dict at: 'Prompt' ifAbsent: [ '' ]).
    conv answer: (dict at: 'Answer' ifAbsent: [ '' ]).

    conv listOfCode:
        ((dict at: 'ListOfCode' ifAbsent: [ #() ]) collect:
            [:codeDict | self parseCodeSnippet: codeDict ]).

    ^ conv

]

{ #category : 'as yet unclassified' }
MSRDataLoader >> parseSharing: dict [
    | sharing |

    sharing := MSRChatGPTSharing new.
    sharing usageType: (dict at: 'UsageType' ifAbsent: [ '' ]).

    "Conversations"
    sharing conversations:
        ((dict at: 'Conversations' ifAbsent: [ #() ]) collect:
            [:convDict | self parseConversation: convDict ]).

    ^ sharing

]

{ #category : 'as yet unclassified' }
MSRDataLoader >> parseSource: dict [
    | source sharings |

    source := MSRSource new.
    source id: (dict at: 'Id' ifAbsent: [ nil ]).
    source type: (dict at: 'Type' ifAbsent: [ '' ]).
    source url: (dict at: 'Url' ifAbsent: [ '' ]).
    source author: (dict at: 'Author' ifAbsent: [ '' ]).
    source points: (dict at: 'Points' ifAbsent: [ 0 ]).
    source attachedUrl: (dict at: 'AttachedUrl' ifAbsent: [ '' ]).
    source title: (dict at: 'Title' ifAbsent: [ '' ]).
    source storyText: (dict at: 'StoryText' ifAbsent: [ '' ]).
    source createdAt: (dict at: 'CreatedAt' ifAbsent: [ '' ]).
    source commentsTotalCount: (dict at: 'CommentsTotalCount' ifAbsent: [ 0 ]).

    "ChatGPT Sharings"

    sharings := (dict at: 'ChatgptSharing' ifAbsent: [ #() ]) collect:
        [:sharingDict | self parseSharing: sharingDict ].

    source chatgptSharings: sharings.

    ^ source

]

{ #category : 'as yet unclassified' }
MSRDataLoader >> sources [
    ^ sources
]
