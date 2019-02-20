Class {
	#name : #DateField,
	#superclass : #Field,
	#instVars : [
		'format'
	],
	#category : #Mold
}

{ #category : #private }
DateField >> disinfect: aString [
	| year month day rs |
	rs := aString readStream.
	^ [ 
	format
		do: [ :token | 
			(#('YYYY' 'MM' 'DD') includes: token)
				ifTrue: [ 
					token = 'YYYY'
						ifTrue: [ year := Number readFrom: rs ].
					token = 'MM'
						ifTrue: [ 
							month := Number readFrom: rs.
							month = 0
								ifTrue: [ ^ nil ] ].
					token = 'DD'
						ifTrue: [ 
							day := Number readFrom: rs.
							day = 0
								ifTrue: [ ^ nil ] ] ]
				ifFalse: [ rs next: token size ] ].
	Date year: year month: month day: day ] on: Error do: [ :ex | nil ]
]

{ #category : #private }
DateField >> format: aDate dayOn: ws [
	ws nextPutAll: (aDate dayOfMonth printPaddedWith: $0 to: 2)
]

{ #category : #private }
DateField >> format: aDate monthOn: ws [
	ws nextPutAll: (aDate monthIndex printPaddedWith: $0 to: 2)
]

{ #category : #private }
DateField >> format: aDate token: aToken on: ws [
	| map function |
	map := Dictionary new.
	map
		at: 'MM' put: #format:monthOn:;
		at: 'DD' put: #format:dayOn:;
		at: 'YYYY' put: #format:yearOn:.
	function := map at: aToken ifAbsent: [ ^ ws nextPutAll: aToken ].
	self perform: function with: aDate with: ws
]

{ #category : #private }
DateField >> format: aDate yearOn: ws [
	ws nextPutAll: (aDate year printPaddedWith: $0 to: 2)
]

{ #category : #accessing }
DateField >> formatString [
	| ws |
	ws := String new writeStream.
	format do: [ :token | ws nextPutAll: token ].
	^ ws contents
]

{ #category : #accessing }
DateField >> formatString: aString [
	"aString should be some combination of MM, DD, and YYYY (use whatever separator you want).
	Note that the input parser doesn't require leading zeros like 'MM' or 'DD' implies, but it prints them in its output.
	
	Examples:
		(ISO format): YYYY-MM-DD
		(USA format): MM/DD/YYYY
		(British): DD/MM/YYYY
		(Swiss) DD.MM.YY
	"

	| chunks |
	chunks := OrderedCollection with: aString.
	#('MM' 'DD' 'YYYY')
		do: [ :placeholder | 
			| tokens |
			tokens := OrderedCollection new.
			chunks
				do: [ :each | 
					| index |
					index := each indexOfSubCollection: placeholder.
					index = 0
						ifTrue: [ tokens add: each ]
						ifFalse: [ 
							| pre post |
							pre := each copyFrom: 1 to: index - 1.
							pre isEmpty
								ifFalse: [ tokens add: pre ].
							tokens add: placeholder.
							post := each copyFrom: index + placeholder size to: each size.
							post isEmpty
								ifFalse: [ tokens add: post ] ] ].
			chunks := tokens ].
	format := chunks asArray
]

{ #category : #private }
DateField >> infect: aDate [
	| ws |
	ws := String new writeStream.
	format do: [ :token | self format: aDate token: token on: ws ].
	^ ws contents
]

{ #category : #private }
DateField >> initialize [
	super initialize.
	self formatString: 'MM/DD/YYYY'
]

{ #category : #rendering }
DateField >> widgetOn: html [
	^(html textInput)
		value: input;
		size: 15;
		yourself
]
