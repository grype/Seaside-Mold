Class {
	#name : #FixedPointField,
	#superclass : #Field,
	#instVars : [
		'scale'
	],
	#category : #Mold
}

{ #category : #private }
FixedPointField >> disinfect: aString [ 
	^ (self scaledDecimalFromString: aString) asScaledDecimal: scale
]

{ #category : #private }
FixedPointField >> infect: aFixedPoint [ 
	^ ((aFixedPoint asScaledDecimal: scale) printString findTokens: 's') first
]

{ #category : #'initialize-release' }
FixedPointField >> initialize [
	super initialize.
	scale := 2
]

{ #category : #accessing }
FixedPointField >> scale [
	^scale
]

{ #category : #accessing }
FixedPointField >> scale: anObject [
	scale := anObject
]

{ #category : #private }
FixedPointField >> scaledDecimalFromString: aString [ 
	"Ripped out of MockGemStone's implemetnation of ScaledDecimal class>>fromString:'"
	| rs ws scl |
	rs := aString readStream.
	ws := String new writeStream.
	rs atEnd ifTrue: [ ^ self error: 'incorrect format' ].
	('+-' includes: rs peek) ifTrue: 
		[ ws nextPut: rs next.
		rs atEnd ifTrue: [ ^ self error: 'incorrect format' ] ].
	[ rs atEnd not and: [ '0123456789' includes: rs peek ] ] whileTrue: [ ws nextPut: rs next ].
	scl := 0.
	(rs atEnd not and: [ rs peekFor: $. ]) ifTrue: 
		[ [ rs atEnd not and: [ '0123456789' includes: rs peek ] ] whileTrue: 
			[ ws nextPut: rs next.
			scl := scl + 1 ] ].
	^ ws contents asNumber / (10 raisedTo: scl) asScaledDecimal: scl
]

{ #category : #private }
FixedPointField >> validateConditions [
	(input notNil and: [ (input matchesRegex: '([-]?)\d+(.\d+)?') not ]) ifTrue: [ errors add: 'Invalid number.' ].
	super validateConditions
]

{ #category : #rendering }
FixedPointField >> widgetOn: html [ 
	^(html textInput)
		value: input;
		size: 10;
		yourself
]
