Class {
	#name : #FieldTest,
	#superclass : #TestCase,
	#category : #Mold
}

{ #category : #running }
FieldTest >> testRequired [
	| field |
	field := StringField new.
	field beRequired.
	field input: ''.
	field validateInput.
	self deny: field isValid.
	field beOptional.
	field input: ''.
	field validateInput.
	self assert: field isValid.
	self assert: field value isNil.
	field beRequired.
	field input: 'text'.
	field validateInput.
	self assert: field isValid.
	self assert: field value = 'text'
]

{ #category : #running }
FieldTest >> testValidateInput [
	| field |
	field := Field new.
	field input: 'Foo Bar'.
	field validateInput.
	self assert: field input = 'Foo Bar'.
	field input: ''.
	field validateInput.
	self assert: field input = nil.
	field input: true.
	field validateInput.
	self assert: field input = true
]
