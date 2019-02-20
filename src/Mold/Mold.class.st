"
This class is little more than a composite of Fields, where Fields do most of the work. It provides a canvas-like API for creating fields and a convenience API for rendering fields on an HTML canvas.

To use a Mold, you typically create and store it in an instance variable of your component. This is part of the object's initialization

buildMold
	mold := Mold new.
	(mold stringField)
		on: #name of: self;
		beRequired.
		 
When rendering the form, you hand it the canvas it will render itself on, and then tell it to render its fields:

renderContentOn: html
	html form:
		[ mold canvas: html.
		html table:
			[ mold renderTableRows. ] ]


"
Class {
	#name : #Mold,
	#superclass : #Object,
	#instVars : [
		'fields',
		'html'
	],
	#category : #Mold
}

{ #category : #'instance creation' }
Mold class >> canvas: aRenderer [
	^self new canvas: aRenderer
]

{ #category : #'instance creation' }
Mold class >> new [
	^super new initialize
]

{ #category : #accessing }
Mold >> at: aKey [ 
	^ fields detect: [:each | each key = aKey] ifNone: [nil]
]

{ #category : #'initialize-release' }
Mold >> canvas: aRenderer [
	html := aRenderer
]

{ #category : #fields }
Mold >> checkboxField [
	^fields add: CheckboxField new
]

{ #category : #accessing }
Mold >> combinedErrorsFrom: aCollectionOfKeys [ 
	^(fields select: [:field | aCollectionOfKeys includes: field key]) 
		inject: Array new
		into: [:errors :each | errors , each errors]
]

{ #category : #fields }
Mold >> dateField [
	^ fields add: DateField new
]

{ #category : #fields }
Mold >> emailField [
	^ self stringField
		addCondition: 
				[ :val | 
				val isNil or: [ val matchesRegex: '([-_\w]\.?)+@[-\w]+\.[-\w]+(\.\w+)*' ] ]
			labeled: 'Invalid email address';
		yourself
]

{ #category : #accessing }
Mold >> errors [
	^fields inject: Array new into: [:errors :each | errors , each errors]
]

{ #category : #rendering }
Mold >> errors: aKeyOrCollection [ 
	((aKeyOrCollection isKindOf: Collection) 
		and: [aKeyOrCollection isString not]) 
			ifFalse: [^ (self at: aKeyOrCollection) renderErrorsOn: html].
	Field renderErrors: (self combinedErrorsFrom: aKeyOrCollection) on: html
]

{ #category : #accessing }
Mold >> example: aKey [ 
	(self at: aKey) renderExampleOn: html
]

{ #category : #accessing }
Mold >> fields [
	^fields
]

{ #category : #fields }
Mold >> fixedPointField [
	^fields add: FixedPointField new
]

{ #category : #fields }
Mold >> hiddenField [
	^fields add: HiddenField new
]

{ #category : #'initialize-release' }
Mold >> initialize [
	fields := OrderedCollection new
]

{ #category : #fields }
Mold >> integerField [
	^fields add: IntegerField new
]

{ #category : #testing }
Mold >> isValid [
	self validate.
	^ fields allSatisfy: #isValid
]

{ #category : #rendering }
Mold >> label: aKey [ 
	(self at: aKey) 
		renderLabelFor: aKey
		on: html
]

{ #category : #rendering }
Mold >> labelAndWidget: aKey [ 
	self label: aKey.
	^ self widget: aKey
]

{ #category : #rendering }
Mold >> paragraph: aKey [ 
	(self at: aKey) renderParagraphOn: html
]

{ #category : #rendering }
Mold >> paragraphs [
	fields do: [:each | each renderParagraphOn: html]
]

{ #category : #rendering }
Mold >> paragraphs: anArrayOfKeys [ 
	anArrayOfKeys do: [ :each | self paragraph: each ]
]

{ #category : #fields }
Mold >> passwordField [
	^fields add: PasswordField new
]

{ #category : #fields }
Mold >> percentageField [
	^self percentageField: 'Invalid percentage'
]

{ #category : #fields }
Mold >> percentageField: anErrorMessage [ 
	^ fields 
		add: (PercentageField new addCondition: 
					[:val | 
					val isNil or: 
							[(val matchesRegex: '(\d)+(.\d+)?%?') 
								or: [val matchesRegex: '(\d)*.(\d)+%?']]]
				labeled: anErrorMessage)
]

{ #category : #removing }
Mold >> remove: aKey [
	| field |
	field := self at: aKey.
	fields remove: field
]

{ #category : #removing }
Mold >> remove: aKey ifAbsent: exceptionBlock [ 
	| field |
	field := self at: aKey.
	fields remove: field ifAbsent: exceptionBlock
]

{ #category : #rendering }
Mold >> requiredFieldStyle: aString [ 
	html text: 'Required fields are shown in '.
	html span
		class: 'required';
		with: aString , '.'
]

{ #category : #rendering }
Mold >> requiredFieldsBold [
	self requiredFieldStyle: 'bold'
]

{ #category : #accessing }
Mold >> save [
	fields do: #save
]

{ #category : #fields }
Mold >> selectField [
	^fields add: SelectField new
]

{ #category : #fields }
Mold >> stringField [
	^fields add: StringField new
]

{ #category : #rendering }
Mold >> tableRow: aKey [ 
	(self at: aKey) renderTableRowOn: html
]

{ #category : #rendering }
Mold >> tableRows [
	fields do: [:each | each renderTableRowOn: html]
]

{ #category : #rendering }
Mold >> tableRows: anArrayOfKeys [ 
	anArrayOfKeys do: [ :each | self tableRow: each ]
]

{ #category : #fields }
Mold >> textField [
	^fields add: TextField new
]

{ #category : #fields }
Mold >> timeField [
	^fields add: TimeField new
]

{ #category : #accessing }
Mold >> validate [
	fields do: [ :each | each validateInput ]
]

{ #category : #accessing }
Mold >> valueAt: aKey [
	^(self at: aKey) value
]

{ #category : #rendering }
Mold >> widget: aKey [ 
	^ (self at: aKey) renderWidgetOn: html
]

{ #category : #fields }
Mold >> zipCodeField [
	^fields add: (StringField new 
				addCondition: [:val | val isNil or: [val matchesRegex: '(\d\d\d\d\d)(-\d\d\d\d)?']]
				labeled: 'Invalid zip code')
]
