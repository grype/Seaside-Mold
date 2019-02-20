Class {
	#name : #HiddenField,
	#superclass : #Field,
	#category : #Mold
}

{ #category : #rendering }
HiddenField >> widgetOn: html [
	^(html hiddenInput)
		value: input;
		yourself
]
