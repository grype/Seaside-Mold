Class {
	#name : #FloatFieldTest,
	#superclass : #TestCase,
	#instVars : [
		'field'
	],
	#category : #Mold
}

{ #category : #running }
FloatFieldTest >> assertValueEquals: aFloat within: aTolerance [
	self assert: (field value - aFloat) abs < aTolerance
]

{ #category : #running }
FloatFieldTest >> setUp [
	field := FloatField new
]

{ #category : #running }
FloatFieldTest >> testBlankInput [
	field input: ''.
	field validateInput.
	self assert: field isValid.
	field beRequired.
	field input: ''.
	field validateInput.
	self deny: field isValid
]

{ #category : #running }
FloatFieldTest >> testInput [
	field input: '5'.
	field validateInput.
	self assert: field isValid.
	self assert: field value = 5.
	field input: '0.2'.
	field validateInput.
	self assert: field isValid.
	self assertValueEquals: 0.2 within: 0.01.
	field input: 'asdf'.
	field validateInput.
	self deny: field isValid.
	field input: '.87'.
	field validateInput.
	self assert: field isValid.
	self assertValueEquals: 0.87 within: 0.001
]
