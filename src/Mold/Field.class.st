"
A field is a basic unit of Form I/O. It can render an input widget on an HTML canvas, validates input from the user, and generates a bona-fide object of the appropriate type.
"
Class {
	#name : #Field,
	#superclass : #Object,
	#instVars : [
		'key',
		'isRequired',
		'conditions',
		'errors',
		'label',
		'value',
		'callback',
		'modifyBlock',
		'input',
		'title',
		'dynamicLabel',
		'example'
	],
	#category : #Mold
}

{ #category : #'instance creation' }
Field class >> new [
	^super new initialize
]

{ #category : #common }
Field class >> renderErrors: aCollection on: html [ 
	aCollection isEmpty ifTrue: [^self].
	(html unorderedList)
		class: 'errors';
		list: aCollection
]

{ #category : #accessing }
Field >> addCondition: aBlock [ 
	self addCondition: aBlock labeled: 'Invalid entry'
]

{ #category : #accessing }
Field >> addCondition: aBlock labeled: aStringOrBlock [ 
	conditions add: aStringOrBlock -> aBlock
]

{ #category : #private }
Field >> addRequirementCondition [
	self addCondition: [:object | isRequired not or: [object notNil]]
		labeled: 'This field is required.'
]

{ #category : #accessing }
Field >> beOptional [
	isRequired := false
]

{ #category : #accessing }
Field >> beRequired [
	isRequired := true
]

{ #category : #accessing }
Field >> beRequired: aStringOrBlock [ 
	self beRequired.
	self requirementCondition key: aStringOrBlock
]

{ #category : #accessing }
Field >> callback: aBlock [ 
	callback := aBlock
]

{ #category : #accessing }
Field >> customize: aBlock [ 
	modifyBlock := aBlock
]

{ #category : #private }
Field >> deriveWidgetID: html [ 
	^ key ifNil: [html nextId]
]

{ #category : #private }
Field >> disinfect: aString [
	"Convert aString into the type of object that this field ultimately represents"
	
	^aString
]

{ #category : #accessing }
Field >> dynamicLabel [
	^ dynamicLabel
]

{ #category : #accessing }
Field >> dynamicLabel: anObject [ 
	dynamicLabel := anObject
]

{ #category : #private }
Field >> dynamicLabelIdFor: id [ 
	^ id asString , 'DynamicLabel'
]

{ #category : #accessing }
Field >> errors [
	^ errors
]

{ #category : #private }
Field >> evaluate: aBlockOrString withPossibleArguments: anArray [
	| args |
	aBlockOrString isBlock
		ifFalse: [ ^ aBlockOrString asString ].
	anArray size == aBlockOrString numArgs
		ifTrue: [ ^ aBlockOrString valueWithArguments: anArray ].
	args := Array new: aBlockOrString numArgs.
	args
		replaceFrom: 1
		to: (anArray size min: args size)
		with: anArray
		startingAt: 1.
	^ aBlockOrString valueWithArguments: args
]

{ #category : #accessing }
Field >> example [
	^ example
]

{ #category : #accessing }
Field >> example: anObject [
	example := anObject
]

{ #category : #private }
Field >> infect: anObject [
	"Convert anObject into the type of object that this field's widget expects for a value"
	
	^anObject
]

{ #category : #'initialize-release' }
Field >> initialize [
	conditions := OrderedCollection new.
	errors := OrderedCollection new.
	isRequired := false.
	self addRequirementCondition
]

{ #category : #accessing }
Field >> input [
	^ input
]

{ #category : #accessing }
Field >> input: val [ 
	| trimmed |
	trimmed := ((val respondsTo: #withBlanksTrimmed) and: [ val isSymbol not ]) 
		ifTrue: [ val withBlanksTrimmed ]
		ifFalse: [ val ].
	input := ((trimmed respondsTo: #isEmpty) and: [ trimmed isEmpty ]) 
		ifTrue: [ nil ]
		ifFalse: [ trimmed ]
]

{ #category : #testing }
Field >> isRequired [
	^ isRequired
]

{ #category : #testing }
Field >> isValid [
	^ errors isEmpty
]

{ #category : #accessing }
Field >> key [
	^ key
]

{ #category : #accessing }
Field >> key: anObject [ 
	key := anObject
]

{ #category : #accessing }
Field >> label [
	^ label
]

{ #category : #accessing }
Field >> label: anObject [ 
	label := anObject
]

{ #category : #accessing }
Field >> on: aSelector of: anObject [ 
	key ifNil: [key := aSelector].
	self value: (anObject perform: aSelector).
	self 
		callback: [:val | anObject perform: (aSelector , ':') asSymbol with: val]
]

{ #category : #rendering }
Field >> renderErrorsOn: html [ 
	self class renderErrors: errors on: html
]

{ #category : #rendering }
Field >> renderExampleOn: html [ 
	^ example ifNotNil: 
		[ html span
			class: 'example';
			with: example ]
]

{ #category : #rendering }
Field >> renderLabelFor: anID on: html [ 
	| tag |
	dynamicLabel ifNotNil: [ self setupDynamicLabelFor: anID ].
	label ifNil: [ ^ self ].
	tag := html label for: anID.
	self isRequired ifTrue: [ tag class: 'required' ].
	tag with: label
]

{ #category : #rendering }
Field >> renderParagraphOn: html [ 
	| id |
	id := self deriveWidgetID: html.
	self isValid ifTrue: 
		[ html paragraph: 
			[ self 
				renderLabelFor: id
				on: html.
			label ifNotNil: [ html break ].
			self 
				renderWidgetId: id
				on: html.
			self renderExampleOn: html ].
		^ self ].
	errors size = 1 
		ifTrue: 
			[ html paragraph: 
				[ self 
					renderLabelFor: id
					on: html.
				html space.
				html span
					class: 'errors';
					with: errors first.
				html break.
				self 
					renderWidgetId: id
					on: html.
				self renderExampleOn: html ] ]
		ifFalse: 
			[ html paragraph: 
				[ self 
					renderLabelFor: id
					on: html ].
			self renderErrorsOn: html.
			html paragraph: 
				[ self 
					renderWidgetId: id
					on: html.
				self renderExampleOn: html ] ]
]

{ #category : #rendering }
Field >> renderTableRowOn: html [ 
	html tableRow: 
		[ | id |
		id := self deriveWidgetID: html.
		html tableData: 
			[ self 
				renderLabelFor: id
				on: html ].
		html tableData: 
			[ self 
				renderWidgetId: id
				on: html.
			self renderExampleOn: html ].
		self isValid ifFalse: [ html tableData: [ self renderErrorsOn: html ] ] ]
]

{ #category : #rendering }
Field >> renderWidgetId: id on: html [
	| tag |
	tag := self widgetOn: html.
	tag
		id: id;
		title: title;
		callback: [ :val | self input: val ].
	dynamicLabel
		ifNotNil: [ 
			| labelId |
			labelId := self dynamicLabelIdFor: id.
			tag
				onFocus: 'if(this.value=="") $("' , labelId , '").className="active"';
				onKeyPress: '$("' , labelId , '").className="hidden"';
				onKeyUp: 'if(this.value=="") $("' , labelId , '").className="active"';
				onBlur: 'if(this.value=="") $("' , labelId , '").className="inactive"' ].
	self isValid
		ifFalse: [ tag class: 'error' ].
	modifyBlock
		ifNotNil: [ 
			modifyBlock numArgs = 2
				ifTrue: [ modifyBlock value: tag value: html ]
				ifFalse: [ 
					modifyBlock numArgs = 1
						ifTrue: [ modifyBlock value: tag ]
						ifFalse: [ modifyBlock value ] ] ].
	^ tag
]

{ #category : #rendering }
Field >> renderWidgetOn: html [ 
	^ self renderWidgetId: (self deriveWidgetID: html) on: html
]

{ #category : #private }
Field >> requirementCondition [
	^ conditions first
]

{ #category : #accessing }
Field >> save [
	callback
		ifNotNil: [ 
			callback numArgs = 1
				ifTrue: [ callback value: value ]
				ifFalse: [ callback value ] ]
]

{ #category : #private }
Field >> setupDynamicLabelFor: anID [ 
	| labelID |
	labelID := self dynamicLabelIdFor: anID.
	self label: 
		[ :html | 
		html span
			id: labelID;
			class: (self input 
					ifNil: [ 'inactive' ]
					ifNotNil: [ 'hidden' ]);
			onClick: '$("' , anID , '").focus()';
			with: dynamicLabel ]
]

{ #category : #accessing }
Field >> title [
	^ title
]

{ #category : #accessing }
Field >> title: anObject [
	title := anObject
]

{ #category : #private }
Field >> validateConditions [
	| disinfected arguments |
	disinfected := [ self disinfect: input ] on: Error do: [ :ex | nil ].
	arguments := Array with: input with: disinfected.
	conditions
		do: [ :each | 
			(self evaluate: each value withPossibleArguments: arguments)
				ifFalse: [ 
					errors add: (self evaluate: each key withPossibleArguments: arguments).
					each = self requirementCondition
						ifTrue: [ ^ self ] ] ]
]

{ #category : #private }
Field >> validateInput [
	errors := OrderedCollection new.
	self validateConditions.
	self isValid ifTrue: [ self value: (input ifNotNil: [ self disinfect: input ]) ]
]

{ #category : #accessing }
Field >> value [
	^ value
]

{ #category : #accessing }
Field >> value: anObject [ 
	value := anObject.
	input := anObject ifNotNil: [self infect: anObject].
	self valueChanged
]

{ #category : #private }
Field >> valueChanged [
]

{ #category : #rendering }
Field >> widgetOn: html [ 
	^ self subclassResponsibility
]
