Class {
	#name : 'MSRCodeSnippet',
	#superclass : 'Object',
	#instVars : [
		'replaceString',
		'type',
		'content'
	],
	#category : 'ProyectoMSRGrupo3-model',
	#package : 'ProyectoMSRGrupo3',
	#tag : 'model'
}

{ #category : 'as yet unclassified' }
MSRCodeSnippet >> content [
    ^ content
]

{ #category : 'as yet unclassified' }
MSRCodeSnippet >> content: aString [
    content := aString
]

{ #category : 'as yet unclassified' }
MSRCodeSnippet >> initialize [
    super initialize.
]

{ #category : 'as yet unclassified' }
MSRCodeSnippet >> printOn: aStream [
    aStream nextPutAll: 'MSRCodeSnippet(', type, ')'.
]

{ #category : 'as yet unclassified' }
MSRCodeSnippet >> replaceString [
    ^ replaceString
]

{ #category : 'as yet unclassified' }
MSRCodeSnippet >> replaceString: aString [
    replaceString := aString
]

{ #category : 'as yet unclassified' }
MSRCodeSnippet >> type [
    ^ type
]

{ #category : 'as yet unclassified' }
MSRCodeSnippet >> type: aString [
    type := aString
]
