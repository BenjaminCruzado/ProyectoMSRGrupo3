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
		'chatgptSharings'
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
MSRSource >> id: anId [
    id := anId.
]

{ #category : 'as yet unclassified' }
MSRSource >> initialize [
    super initialize.
    chatgptSharings := OrderedCollection new.
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
