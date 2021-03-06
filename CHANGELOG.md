# Changelog for the API documentation.

Please add a changelog here each time you update the API documentation.

# 2021-07-01 : fixed typo overriden to overridden

* fixed typo overriden to overridden

# 2021-06-29 : added all cluster management endpoints

* added all endpoints in Organization > Clusters section
* added all endpoints in Organization > Cloud provider Credentials section
* added DEPLOYING status for cluster
* changed response for GET aws, do and scaleway credentials --> it only returns the name of the set of credentials. Meaning that access_key_id and secret_access_key can only be created or updated, but not read
* removed auto_delete from deployment rule resource

# 2021-06-18 : env variables and secrets change

* removed dryRun parameter everywhere
* removed scope from editable fields in PUT

# 2021-06-14 : changed BUSINESS to STARTUP in orga plan field

* changed BUSINESS to STARTUP in "plan" field of an organization

# 2021-06-14 : changed FREE to COMMUNITY in orga plan field

* changed FREE to COMMUNITY in "plan" field of an organization

# 2021-06-11 : added BETA tag and information at the top of the doc

* added note at the very beginning of the doc to inform it is still in beta and not all endpoints are supported yet.

# 2021-06-07 : added date range on currentCostn endpoint

* added "billing_started_on" and "billing_ended_on" for orga, project and env in GET organization/id/currentCost endpoint

# 2021-06-04 : improvements on orga billing

* added "message" field in GET organization/id/billingStatus in order to explain to the user why his status can be invalid
* changed EUR currency_code examples to USD as we'll handle only USD at first

# 2021-06-03 : added GET /account

* added GET /account
* fixed something that was generating error on open api format validator (does not change the API doc spec)

# 2021-06-02 : fixed isses on env deployment rule

* updated GET environment/id/deploymentRule and PUT environment/id/deploymentRule/id

# 2021-06-01 : updates on organization and account

* removed "plan" from PUT organization/id request body
* added GET account/referral
* added POST account/rewardClaim
* added GET organization/id/billingStatus

# 2021-05-27 : updated orga billing section

* budget threshold now optional in GET currentCost
* company now optional in billingInfo
* removed publicly_accessible = true on application ports. This logic will be handled on frontend

# 2021-05-26 : updated orga section

* added fields in the organization resource (repository, logo_url, icon_url, owner)
* added endpoint GET organization/id/member listing the members.

# 2021-05-25 : updated app ports and storage management, and commits resource

* changed GET application/id/commit payload : removed user field and replaced it by author_name and author_avatar_url fields.
* added id for storage and port objects in application payload. These are nullable fields. It allows backend to know when receiving a PUT application/id if they have to create/update/delete a storage or a port.
* added description in project payload

# 2021-05-21 : removed repo name from application creation and edition endpoints

* removed "name" inside "git_repository" object in application POST and PUT calls

# 2021-05-20 : fixes on orga billing and on other calls (env and project stats and list of statuses for apps and dbs)

* fixed responses payload for PUT orga/id/billingInfo that was incorrect
* added budget_exceeded true/false on Get orga/id/currentCost
* updated CREATE environment endpoint to specify cluster id in request body rather than cloud provider name and region
* fixed GET organization/id/project/stats to return a list and not a single result
* fixed GET project/id/environment/stats to return a list and not a single result
* fixed GET environment/id/application/status to return a list and not a single result
* fixed GET environment/id/database/status to return a list and not a single result
* changed disk_name to storage_id in GET application/id/currentStorage
* added "default = BUILDPACKS" on application "build_mode" field
* removed owner and provider fields in git_repository object of Application creation and edition endpoints

# 2021-05-19 : removed last_commit fields in application resource and other minor fixes

* removed last_commit_id and last_commit_tag from git_repository object inside application resource
* remove apgination from GE application/id/commit
* removed "required" tag on "cloud_provider" field when creating an environment
* added "plan" field in orgabization resource

# 2021-05-18 : removed get environment/id/service

* removed get environment/id/service
* moved app and db list on the environment section
* changed get project/id/environment/service/number to get project/id/environment/stats
* added current metric calls for app and db at env level so get environment/id/application/instance, get environment/id/application/currentStorage, get environment/id/application/currentScale and get environment/id/database/currentMetric

# 2021-05-17 : made orga billing part and small fixes

* small fixe: removed reference_branch from PUT env/id (because we removed this field from the env resource)
* small fix: removed name from GET application/id/link response and GET environment/id/link
* small fix : added id, created_at and updated_at env GET environment/id/deploymentRule (don't know why I did not add it before)
* added all endpoints in "billing" part of "Organization" section
 
# 2021-05-14 : added port name on aplication

* added "name" on application port

# 2021-05-12 : changed on git auth provider

* corrected typo in GET application/id/instance (previously it was Instance)
* removed storage from GET application/id/instance
* added endpoint GET application/id/currentStorage to list storage disks
* updated endpoint GET application/id/metric/storage to list storage disks instead of instances

# 2021-05-11 : changed on git auth provider

* removed credentials field in GET account/gitAuthProvider
* removed updated_at and created_at from GET account/gitAuthProvider GET account/github(gitlab)/repository
* updated id of GET account/gitAuthProvider and GET account/github(gitlab)/repository to specify it's a id/text not a uuid
* removed reference_branch from environment resource

# 2021-05-10 : changed according to feedbacks

* added "owern" (string) field on GET account/gitAuthProvider response
* removed status, hint, execution id from Application logs (GET application/id/log). Put the "message" directly in the resource
* changed GET environment/id/log response format : state and message are now directly inlined and not in a "'status" object

# 2021-05-07 : minor updates here and there

* added "last_updated_by" on environment resource
* changed database storage field to specify unit is MB and not GB, and that default is 10240

# 2021-05-06 : remove pagination on logs

* removed pagination concept on app and env logs
* added dry run query param for env var and secrets

# 2021-05-05 : changes on instance and status

* removed updated_at and id on instance
* added QUEUED state

# 2021-05-04 : changed regarding commit info, new endpoint for outdated apps

* removed "storage" as possible database type in database resource
* put in uppercase the enum values in database resource
* removed storage name in GET application/id
* added deployed_commit_tag, last_commit_id and last_commit_tag in application resource. This way in application resource (in git_repository object) we have on one side the deployed_commit information which is the current version of the app, that has been deployed, and also the last_commit information which is the latest version of the app (that may not been deployed yet). For instance if deployed_commit_id is not equal to last_commit_id it means the app is not up to date
* added "tag" field in commit resource (GET application/id/commit)
* added new endpoint GET environment/id/application/to-update that lists all apps of the env that are not up-to-date (last commit id not equal to deployed commit id)
* added GET environment/id/databaseConfiguration that returns list of database types, and for each of them, versions and modes that are supported.

# 2021-05-03 : update create app, env, database endpoints to specify required and default values

* changed tag on POST application and POST database to make them appear in the doc
* updated root_path field to be mandatory on application creation endpoint
* updated mode field to be mandatory on database creation endpoint
* updated database accessibility field to specify default value = private
* updated database storage field to specify default value = 10


# 2021-04-29 : merge git repo linking call with application POST/PUT + added calls on app/database

* removed POST application/id/repository
* added repository linking in POST application and PUT application/id
* added POST/DEL application/id/database/id
* added GET application/id/database
* updated all deploy, restart, stop endpoints (app, env, database) to return the object status instead of the object payload.

# 2021-04-28 : updates linked to all calls regarding deployment

* removed POST application/id/rollback
* updated git_commit_id to be mandatory in /deploy calls
* replaced last_commit_id, last_commit_date, last_commit_contributor to deployed_commit_id, deployed_commit_date and deployed_commit_contributor
* added deployed_commit_id in GET environment/id/service
* added pagination GET application/id/commit and add query param ?git_commit_id
* added GET application/id/deploymentHistory with possible query parameters ?status= and ?git_commit_id=
* updated deploymentHistory resource (for env and app) so that possible statuses can be "success" and "failed".
* added "to_update" field on GET environment/id/service

# 2021-04-26 : DEL and PUT api call on domain put at the application level, and small updates

* deleted DEL customDomain/id
* added DEL application/id/customDomain/id
* deleted PUT customDomain/id
* added PUT application/id/customDomain/id
* updated POST environment/id/restart to add an option "restart_db" true/false in the payload


# 2021-04-26 : updated status object, removed abort endpoints and fixed issue in app and db creation endpoints

* added RUNNING_ERROR as a possible state
* removed POST application/id/abort --> we will only have /stop endpoint, in order to reduce confusion for end-user.
* removed POST application/id/abort and POST environment/id/abort  --> we will only have /stop endpoint, in order to reduce confusion for end-user.
* fixed app and db creation endpoints : removed maximum_cpu and maxmum_memory, as these are read only fields

# 2021-04-22 : updated deployment rule resource and added endpoint for database versions

* changed "selectors" field of project deployment rule to "environment_target" that is a string (will contain a regex)
* added "always_up" field in deployment rule resource. And added "nullable:true" on "start_time", "stop_time" and "weekday"
* added endpoint GET database/id/version that lists the elligible versions for the given database based on databse type (redis, postgresql...) and mode (managed or container)

# 2021-04-21 : added deployment rule endpoints on project and environment

* removed "created_at", "updated_at" for application tag.
* added POST application/id/tag
* added DEL application/id/tag/id
* created new endpoint GET/POST project/id/deploymentRule
* created new endpoints GET/PUT/DEL project/id/deploymentRule/id/
* created new endpoint GET environment/id/deplopymentRule
* created new endpoint PUT environment/id/deplopymentRule/id

# 2021-04-20 : updated project resource and endpoints

* added maximum_cpu and maximum_memory in database resource
* added maximum_cpu and maximum_memory in application resource
* added description in Project resource
* added GET project/id/environment/status --> returns list of environment id and status
* added GET project/id/environment/service/number --> returns list of environment id, and total number of services
* added GET organization/id/project/stats --> returns list of project id, and total number of services and environments.

# 2021-04-19 : updated log resource

* renamed "service" field to "scope" in environment logs as a log can concern an environment

# 2021-04-16 : updated log resource

* removed "message" from log resource, as there is already a message inside the "status" object of the log
* added execution_id to log resource
* added ENVIRONMENT as possible service type for environment logs
* added type, message and log_id in Event resource
* removed POST application/id/event/id/rollback
* added mode and accessibility fields in database ressource (mode is not editable, accessibility is editable)

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
