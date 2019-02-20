Class {
	#name : #TextField,
	#superclass : #StringField,
	#category : #Mold
}

{ #category : #rendering }
TextField >> widgetOn: html [
	^(html textArea)
		value: input;
		yourself
]
