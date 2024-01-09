Extension { #name : #FamixJavaMethod }

{ #category : #'*Famix2Java' }
FamixJavaMethod >> isVoid [
^ self declaredType  isPrimitiveType and: [ self declaredType name = #void ].
]
