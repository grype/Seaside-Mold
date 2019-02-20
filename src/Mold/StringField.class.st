Class {
	#name : #StringField,
	#superclass : #Field,
	#category : #Mold
}

{ #category : #rendering }
StringField >> widgetOn: html [ 
	^ (html textInput)
		value: input;
		yourself
]
