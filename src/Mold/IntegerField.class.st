Class {
	#name : #IntegerField,
	#superclass : #Field,
	#category : #Mold
}

{ #category : #private }
IntegerField >> disinfect: aString [ 
	(aString reject: [:each | each isDigit]) notEmpty ifTrue: [^nil].
	^ [aString asNumber] on: Error do: [:ex | nil ]
]

{ #category : #private }
IntegerField >> infect: anInteger [ 
	^ anInteger printString
]

{ #category : #private }
IntegerField >> validateConditions [
	super validateConditions.
	self isValid ifFalse: [ ^ self ].
	input ifNil: [ ^ self ].
	(self disinfect: input) isInteger ifFalse: [ errors add: 'Fractions and decimals are not allowed here.' ]
]

{ #category : #rendering }
IntegerField >> widgetOn: html [ 
	^(html textInput)
		value: input;
		size: 6;
		yourself
]
