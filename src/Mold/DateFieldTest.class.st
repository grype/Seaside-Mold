Class {
	#name : #DateFieldTest,
	#superclass : #TestCase,
	#instVars : [
		'field'
	],
	#category : #Mold
}

{ #category : #running }
DateFieldTest >> setUp [
	field := DateField new
]

{ #category : #tests }
DateFieldTest >> testDefaultFormat [
	self assert: field formatString = 'MM/DD/YYYY'
]

{ #category : #tests }
DateFieldTest >> testDisinfectISO [
	field formatString: 'YYYY-MM-DD'.
	self assert: (field disinfect: '2010-08-06') = (Date year: 2010 month: 8 day: 6).
	self assert: (field disinfect: '1234-11-22') = (Date year: 1234 month: 11 day: 22).
	self assert: (field disinfect: '2009-1-14') = (Date year: 2009 month: 1 day: 14).
	self assert: (field disinfect: '2009-10-2') = (Date year: 2009 month: 10 day: 2).
	self shouldnt: [ field disinfect: '1234-11-32' ] raise: Error.	"invalid, but some implementations just jump to the next month"
	self assert: (field disinfect: '1-1') isNil.
	self assert: (field disinfect: 'blah') isNil
]

{ #category : #tests }
DateFieldTest >> testDisinfectUK [
	field formatString: 'DD/MM/YYYY'.
	self assert: (field disinfect: '09/08/2010') = (Date year: 2010 month: 8 day: 9).
	self shouldnt: [ field disinfect: '09/13/2010' ] raise: Error "invalid, but some implementations just jump to the next month"
]

{ #category : #tests }
DateFieldTest >> testDisinfectUS [
	field formatString: 'MM/DD/YYYY'.
	self assert: (field disinfect: '08/09/2010') = (Date year: 2010 month: 8 day: 9)
]

{ #category : #tests }
DateFieldTest >> testInfectISO [
	field formatString: 'YYYY-MM-DD'.
	self assert: (field infect: (Date year: 1999 month: 12 day: 31)) = '1999-12-31'
]

{ #category : #tests }
DateFieldTest >> testInfectUK [
	field formatString: 'DD/MM/YYYY'.
	self assert: (field infect: (Date year: 1999 month: 12 day: 31)) = '31/12/1999'
]

{ #category : #tests }
DateFieldTest >> testInfectUS [
	field formatString: 'MM/DD/YYYY'.
	self assert: (field infect: (Date year: 1999 month: 12 day: 31)) = '12/31/1999'.
	self assert: (field infect: (Date year: 2009 month: 7 day: 8)) = '07/08/2009'
]

{ #category : #tests }
DateFieldTest >> testValidateInput [
	field input: String new.
	field validateInput.
	self assert: field isValid.
	field beRequired.
	field validateInput.
	self deny: field isValid.
	field input: ''
]

{ #category : #tests }
DateFieldTest >> testValidationOnDate [
	field beRequired.
	field addCondition: [ :input :disinfected | disinfected >= (Date year: 2010 month: 1 day: 1) ].
	field input: '12/31/2009'.
	field validateInput.
	self deny: field isValid.
	field input: '01/01/2010'.
	field validateInput.
	self assert: field isValid
]
