# Changelog for the API documentation.

Please add a changelog here each time you update the API documentation.

# 2021-04-15 : added environment logs and business rules on DEL/PUT for environment variables and secrets

* added calls regarding environment logs, which correspond to deployment logs. They have same payload as application/id/logs but with "service" info in addition, and the exact same logic.
* GET environment/id/log (paginated call, with query param startId)
* GET environment/id/log?tail= (not paginated call)
* GET environment/id/log?lastId= (not paginated call)
* fixed GET application/id/log call, because response payload was not paginated, it was because of a syntax error.
* updated PUT {application/environment/project}/id/environmentVariable/id to add key and scope
* updated PUT {application/environment/project}/id/environmentVariable/id to add business rules in description
* updated PUT {application/environment/project}/id/secret/id to add business rules in description
* updated DEL {application/environment/project}/id/environmentVariable/id to add business rules in description
* updated DEL {application/environment/project}/id/secret/id to add business rules in description

# 2021-04-14 : changes based on Romain's feedbacks

* updated application resource fields cpu, memomry, and storage size, to change their type to "number" instead of "string". Added in each field description the unit that is used.
* same thing on database resource
* updated application resource, to specify default port to HTTP instead of HTTPS
* added INITIALIZED in status possible values
* removed status field from application, database and environment resources
* added GET application/id/status
* added GET database/id/status
* added GET environment/id/status
* added GET environment/id/service/status --> returns a list of id (the id of each service) and associated status
* added GET environment/id/application/status --> returns a list of id (the id of each app) and status
* added GET environment/id/database/status --> returns a list of id (the id of each db) and associated status
* updated application log resource to remove user, commit and message_human_explanation field
* removed POST database/id/clone call
* updated POST environment/id/clone to request name in body request, for the new env that will be created. Added also a description on the endpoint

# 2021-04-13 : changes based on Patryk's feedbacks

* updated commit resource to remove id and updated_at fields
* updated application log resource to remove updated_at field
* renamed "owner" field to "user" in application log
* fixed issue on GET application/id/log. There was an issue, the body response was not displayed
* updated POST application/id/event/id/rollback response to respond the application resource instead of newly created event
* added description for calls allowing to create override/alias on env variables/secrets, to explain that the response body will contain the newly created variable/secret
* removed POST database/id/application/{targetedApplicationId} that allowed to attach an app to a database. We removed that action in the web UI. User will have to go to his application settings to make the link between app and logical database. It also reduces confusion as there were a lot of calls on the app/database/logicalDatabase links. Besides, attach an app to a database is not very useful. The interesting action for the user is to attach a logicalDatabase to his app. I only let the DEL database/id/application/{targetedApplicationId}. This way the user will not have to remove each logical database one by one from the application settings, but can remove the app from the database.
* added description in GET application/id/links and GET environment/id/links
* removed request body on POST environment/id/deploy (before we were asking for commit_id, which was a copy/paste error. the call triggers the depoloyment of all apps/dbs to their latest versions)