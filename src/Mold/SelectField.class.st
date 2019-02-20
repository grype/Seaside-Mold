Class {
	#name : #SelectField,
	#superclass : #Field,
	#instVars : [
		'list',
		'labels',
		'onChange',
		'optionalLabel'
	],
	#category : #Mold
}

{ #category : #initialization }
SelectField >> initialize [
	super initialize.
	optionalLabel := 'Please Select'
]

{ #category : #private }
SelectField >> labelFor: anObject [
	^labels ifNil: [anObject] ifNotNil: [labels value: anObject]
]

{ #category : #accessing }
SelectField >> labels [
	^labels
]

{ #category : #accessing }
SelectField >> labels: anObject [
	labels := anObject
]

{ #category : #accessing }
SelectField >> list [
	^list
]

{ #category : #accessing }
SelectField >> list: anObject [
	list := anObject
]

{ #category : #accessing }
SelectField >> onChange [
	^ onChange
]

{ #category : #accessing }
SelectField >> onChange: anObject [
	onChange := anObject
]

{ #category : #accessing }
SelectField >> optionalLabel: aString [ 
	optionalLabel := aString
]

{ #category : #rendering }
SelectField >> widgetOn: html [ 
	| tag |
	tag := html select.
	tag selected: input.
	onChange ifNotNil: [tag onChange: (onChange value: html)].
	self isRequired 
		ifTrue: 
			[tag list: list.
			tag labels: [:item | self labelFor: item]]
		ifFalse: 
			[tag list: #(nil ) , list.
			tag 
				labels: [:item | item ifNil: [optionalLabel] ifNotNil: [self labelFor: item]]].
	^ tag
]
