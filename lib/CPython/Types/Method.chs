-- Copyright (C) 2009 John Millikin <jmillikin@gmail.com>
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- 
{-# LANGUAGE ForeignFunctionInterface #-}
module CPython.Types.Method
	( Method
	, methodType
	, new
	, function
	, self
	) where
import CPython.Internal hiding (new)
import Foreign (nullPtr)

#include <hscpython-shim.h>

newtype Method = Method (ForeignPtr Method)

instance Object Method where
	toObject (Method x) = SomeObject x
	fromForeignPtr = Method

instance Concrete Method where
	concreteType _ = methodType

{# fun pure hscpython_PyMethod_Type as methodType
	{} -> `Type' peekStaticObject* #}

{# fun hscpython_PyMethod_New as new
	`(Object func, Object self)' =>
	{ withObject* `func'
	, withObject* `self'
	} -> `Method' stealObject* #}

{# fun PyMethod_Function as function
	{ withObject* `Method'
	} -> `SomeObject' peekObject* #}

{# fun PyMethod_Self as self
	{ withObject* `Method'
	} -> `SomeObject' peekObject* #}
