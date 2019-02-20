Class {
	#name : #TimeField,
	#superclass : #Field,
	#category : #Mold
}

{ #category : #private }
TimeField >> disinfect: aString [
	^Time readFrom: aString withBlanksTrimmed readStream
]

{ #category : #private }
TimeField >> infect: aTime [
	^aTime asString
]

{ #category : #rendering }
TimeField >> widgetOn: html [
	^(html textInput)
		value: input;
		size: 6;
		yourself
]
