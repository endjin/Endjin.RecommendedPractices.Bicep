# Internal Modules

This folder contains Bicep templates that are used to share 'library-like' functionality between modules - they are not published to the registry in their standalone form, but are effectively embedded within any module that consumes them.

* [alerting-helpers](alerting-helpers.bicep) - provides lookup & string formatting functionality useful to alerting scenarios