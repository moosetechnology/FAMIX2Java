Extension { #name : #FAMIXAnnotationInstance }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXAnnotationInstance >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitAnnotationInstance: self
]
