Extension { #name : #FAMIXEnumValue }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXEnumValue >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitEnumValue: self
]
