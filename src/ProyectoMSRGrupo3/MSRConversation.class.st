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
MSRConversation >> answerLength [
    "Devuelve la longitud de la respuesta en número de caracteres."
    ^ self answer ifNil: [ 0 ] ifNotNil: [ self answer size ]
]

{ #category : 'as yet unclassified' }
MSRConversation >> codeLanguage [
    "Devuelve el lenguaje del primer snippet de código si existe, o nil si no hay código."
    ^ (self listOfCode isEmpty) ifTrue: [ nil ] ifFalse: [ (self listOfCode first) type ]
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

{ #category : 'as yet unclassified' }
MSRConversation >> promptLength [
    "Devuelve la longitud del prompt en número de caracteres."
    ^ self prompt ifNil: [ 0 ] ifNotNil: [ self prompt size ]
]
