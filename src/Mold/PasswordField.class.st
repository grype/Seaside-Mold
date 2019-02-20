Class {
	#name : #PasswordField,
	#superclass : #StringField,
	#category : #Mold
}

{ #category : #rendering }
PasswordField >> widgetOn: html [
	^html passwordInput
]
