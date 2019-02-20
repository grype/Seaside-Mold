Class {
	#name : #FloatField,
	#superclass : #Field,
	#category : #Mold
}

{ #category : #private }
FloatField >> disinfect: aString [
	| trimmed rs |
	trimmed := aString withBlanksTrimmed select: [ :char | '1234567890.' includes: char ].
	trimmed isEmpty
		ifTrue: [ ^ nil ].
	(trimmed first = $. and: [ (trimmed occurrencesOf: $.) = 1 ])
		ifTrue: [ trimmed := '0' , trimmed ].
	rs := trimmed readStream.
	^ [ Number readFrom: rs ] on: Error do: [ :ex | nil ]
]

{ #category : #private }
FloatField >> infect: aNumber [ 
	^ aNumber asFloat printString
]

{ #category : #private }
FloatField >> validateConditions [
	super validateConditions.
	self isValid ifFalse: [ ^ self ].
	input ifNil: [ ^ self ].
	(self disinfect: input) ifNil: [ errors add: 'Invalid number.' ]
]

{ #category : #rendering }
FloatField >> widgetOn: html [ 
	^(html textInput)
		value: input;
		yourself
]
