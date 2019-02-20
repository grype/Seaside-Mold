Class {
	#name : #ExampleForm,
	#superclass : #WAComponent,
	#instVars : [
		'mold',
		'format'
	],
	#category : #Mold
}

{ #category : #testing }
ExampleForm class >> canBeRoot [
	^true
]

{ #category : #testing }
ExampleForm class >> initialize [
	"self initialize"
	
	super initialize.
	self registerAsApplication: 'examples/mold'
]

{ #category : #initialization }
ExampleForm >> buildMold [
	| name email confirmEmail |
	mold := Mold new.
	name := mold stringField
		key: #name;
		label: 'Your Name:';
		beRequired;
		addCondition: [ :val | val matchesRegex: '\w+ \w+' ]
			labeled: 
				[ :wrong | 
				'Please enter your first and last name. I couldn''t find a space in <1s>' expandMacrosWith: wrong ].
	email := mold emailField
		key: #email;
		label: 'Email Address:'.
	confirmEmail := mold emailField
		key: #confirmEmail;
		label: 'Confirm Email:'.
	email 
		addCondition: [ :input | input = confirmEmail input ]
		labeled: 'Email addresses did not match.'.
	confirmEmail 
		addCondition: [ :input | input = email input ]
		labeled: 'Email addresses did not match.'.
	mold textField
		key: #about;
		label: 'Please tell us more about yourself.';
		beRequired;
		customize: 
			[ :textarea | 
			textarea
				rows: 5;
				columns: 60 ].
	mold checkboxField
		key: #spamMe;
		label: 'Yes, please sign me up for the email newsletter!';
		addCondition: [ :val | name isValid not or: [ val or: [ name value first = $K ] ] ]
			labeled: 'Sorry, you may not opt out of our spam unless your first name starts with K.';
		value: true
]

{ #category : #initialization }
ExampleForm >> initialize [
	super initialize.
	format := #table.
	self buildMold
]

{ #category : #rendering }
ExampleForm >> renderContentOn: html [ 
	self renderFormatChoicesOn: html.
	html paragraph: 'Mold is a tool for building forms. It can render the forms for you, or you can render them yourself.'.
	html form: 
		[ mold canvas: html.
		format = #table 
			ifTrue: [ html table: [ mold tableRows ] ]
			ifFalse: 
				[ format = #paragraphs 
					ifTrue: [ mold paragraphs ]
					ifFalse: [ self renderCustomOn: html ] ].
		html submitButton
			value: 'Submit Form';
			callback: [ mold isValid ifTrue: [ mold inspect ] ] ]
]

{ #category : #rendering }
ExampleForm >> renderCustomOn: html [ 
	html table: 
		[ mold tableRow: #name.
		html tableRow: 
			[ html
				tableData: [ mold label: #email ];
				tableData: [ mold widget: #email ];
				tableData: [ mold label: #confirmEmail ];
				tableData: [ mold widget: #confirmEmail ];
				tableData: [ mold errors: #email ] ] ].
	mold paragraph: #about.
	mold paragraph: #spamMe
]

{ #category : #rendering }
ExampleForm >> renderFormatChoicesOn: html [
	html
		paragraph:
			[(html anchor)
				callback: [format := #table];
				with: 'Table'.
			html space.
			(html anchor)
				callback: [format := #paragraphs];
				with: 'Paragraphs'.
			html space.
			(html anchor)
				callback: [format := #custom];
				with: 'Custom']
]

{ #category : #rendering }
ExampleForm >> style [
	^'
label.required { font-weight: bold; }
.errors { color: red; margin: 0; vertical-align: top }
.error { background-color: #fcc; }
'
]
