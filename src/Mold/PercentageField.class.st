Class {
	#name : #PercentageField,
	#superclass : #FloatField,
	#category : #Mold
}

{ #category : #private }
PercentageField >> disinfect: aString [ 
	^ (super disinfect: aString) ifNotNilDo: [ :number | (number / 100) asFloat ]
]

{ #category : #private }
PercentageField >> infect: aNumber [ 
	^ super infect: aNumber * 100
]
