Class {
	#name : #CheckboxField,
	#superclass : #Field,
	#category : #Mold
}

{ #category : #rendering }
CheckboxField >> renderParagraphOn: html [
	html
		paragraph:
			[| id |
			id := html nextId.
			self renderWidgetId: id on: html.
			self renderLabelFor: id on: html].
	self isValid ifFalse: [self renderErrorsOn: html]
]

{ #category : #rendering }
CheckboxField >> renderTableRowOn: html [
	html
		tableRow:
			[html tableData.
			html
				tableData:
					[| id |
					id := html nextId.
					self renderWidgetId: id on: html.
					self renderLabelFor: id on: html].
			self isValid ifFalse: [html tableData: [self renderErrorsOn: html]]]
]

{ #category : #rendering }
CheckboxField >> widgetOn: html [
	^(html checkbox)
		value: input;
		yourself
]
