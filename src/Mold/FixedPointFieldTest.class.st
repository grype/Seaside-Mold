Class {
	#name : #FixedPointFieldTest,
	#superclass : #TestCase,
	#instVars : [
		'field'
	],
	#category : #Mold
}

{ #category : #running }
FixedPointFieldTest >> setUp [
	field := FixedPointField new scale: 2
]

{ #category : #running }
FixedPointFieldTest >> testInput [
	field input: '5'.
	field validateInput.
	self assert: field isValid.
	self assert: field value = (5 asScaledDecimal: 2).
	field input: '-0.2'.
	field validateInput.
	self assert: field isValid.
	self assert: field value = (-2 / 10 asScaledDecimal: 2).
	field input: 'asdf'.
	field validateInput.
	self deny: field isValid.
	field input: '0'.
	field validateInput.
	self assert: field isValid.
	self assert: field value = 0
]

{ #category : #tests }
FixedPointFieldTest >> testRequirement [
	field beRequired.
	field input: ''.
	field validateInput.
	self deny: field isValid.
	self assert: field errors size = 1.
	field input: '234.567'.
	field validateInput.
	self assert: field isValid
]
