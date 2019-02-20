Class {
	#name : #PercentageFieldTest,
	#superclass : #TestCase,
	#instVars : [
		'field'
	],
	#category : #'Mold-Tests'
}

{ #category : #running }
PercentageFieldTest >> assertValueEquals: aFloat within: aTolerance [
	self assert: (field value - aFloat) abs < aTolerance
]

{ #category : #'initialize-release' }
PercentageFieldTest >> setUp [
	field := PercentageField new
]

{ #category : #running }
PercentageFieldTest >> testBlankInput [
	field
		input: '';
		validateInput.
	self assert: field isValid.
	field
		beRequired;
		input: '';
		validateInput.
	self deny: field isValid
]

{ #category : #running }
PercentageFieldTest >> testInput [
	field input: '5'.
	field validateInput.
	self assert: field isValid.
	self assertValueEquals: 0.05 within: 0.001.
	field input: '0.2'.
	field validateInput.
	self assert: field isValid.
	self assertValueEquals: 0.002 within: 0.0001.
	field input: '.9'.
	field validateInput.
	self assert: field isValid.
	self assertValueEquals: 0.009 within: 0.0001
]
