Class {
	#name : #IntegerFieldTest,
	#superclass : #TestCase,
	#instVars : [
		'field'
	],
	#category : #'Mold-Tests'
}

{ #category : #running }
IntegerFieldTest >> setUp [
	field := IntegerField new
]

{ #category : #running }
IntegerFieldTest >> testBlankInput [
	field input: ''.
	field validateInput.
	self assert: field isValid.
	field beRequired.
	field input: ''.
	field validateInput.
	self deny: field isValid
]

{ #category : #running }
IntegerFieldTest >> testInput [
	field input: '5'.
	field validateInput.
	self assert: field isValid.
	self assert: field value = 5.
	field input: '0.2'.
	field validateInput.
	self deny: field isValid.
	field input: '.9'.
	field validateInput.
	self deny: field isValid
]
