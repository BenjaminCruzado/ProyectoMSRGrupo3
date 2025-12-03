Class {
	#name : 'MSRChatGPTSharing',
	#superclass : 'Object',
	#instVars : [
		'usageType',
		'dateOfAccess',
		'conversations'
	],
	#category : 'ProyectoMSRGrupo3-model',
	#package : 'ProyectoMSRGrupo3',
	#tag : 'model'
}

{ #category : 'as yet unclassified' }
MSRChatGPTSharing >> addConversation: aConversation [
    conversations add: aConversation.
]

{ #category : 'as yet unclassified' }
MSRChatGPTSharing >> conversations [
    ^ conversations
]

{ #category : 'as yet unclassified' }
MSRChatGPTSharing >> conversations: aCollection [
    conversations := aCollection
]

{ #category : 'as yet unclassified' }
MSRChatGPTSharing >> dateOfAccess [
    ^ dateOfAccess
]

{ #category : 'as yet unclassified' }
MSRChatGPTSharing >> dateOfAccess: aDateTime [
    dateOfAccess := aDateTime.
]

{ #category : 'as yet unclassified' }
MSRChatGPTSharing >> initialize [
    super initialize.
    conversations := OrderedCollection new.
]

{ #category : 'as yet unclassified' }
MSRChatGPTSharing >> usageType [
    ^ usageType
]

{ #category : 'as yet unclassified' }
MSRChatGPTSharing >> usageType: aString [
    usageType := aString
]
