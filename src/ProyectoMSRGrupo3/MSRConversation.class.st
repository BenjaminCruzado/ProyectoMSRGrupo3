Class {
	#name : 'MSRConversation',
	#superclass : 'Object',
	#instVars : [
		'prompt',
		'answer',
		'listOfCode'
	],
	#category : 'ProyectoMSRGrupo3-model',
	#package : 'ProyectoMSRGrupo3',
	#tag : 'model'
}

{ #category : 'as yet unclassified' }
MSRConversation >> addCode: aCodeSnippet [
    listOfCode add: aCodeSnippet.
]

{ #category : 'as yet unclassified' }
MSRConversation >> answer [
    ^ answer
]

{ #category : 'as yet unclassified' }
MSRConversation >> answer: aString [
    answer := aString.
]

{ #category : 'as yet unclassified' }
MSRConversation >> initialize [
    super initialize.
    listOfCode := OrderedCollection new.
]

{ #category : 'as yet unclassified' }
MSRConversation >> listOfCode [
    ^ listOfCode
]

{ #category : 'as yet unclassified' }
MSRConversation >> listOfCode: aCollection [
    listOfCode := aCollection
]

{ #category : 'as yet unclassified' }
MSRConversation >> prompt [
    ^ prompt
]

{ #category : 'as yet unclassified' }
MSRConversation >> prompt: aString [
    prompt := aString.
]
