Extension { #name : #FamixJavaParameterizedType }

{ #category : #'*Famix2Java' }
FamixJavaParameterizedType >> allParametrizedClasses [

	^ ((self arguments
		    collect: [ :arg | arg allParametrizedClasses ]
		    as: OrderedCollection) , { self parameterizableClass })
		  flattened
]
