# This is a design draft document

## SQL schema draft

```sql
CREATE TABLE _user
(
    id UUID PRIMARY KEY
);

CREATE TABLE organization
(
    id       UUID PRIMARY KEY,
    owner_id UUID NOT NULL REFERENCES _user (id),
);

CREATE TABLE project
(
    id              UUID PRIMARY KEY,
    created_at      TIMESTAMP NOT NULL DEFAULT now(),
    organization_id UUID      NOT NULL REFERENCES organization (id),
    owner_id        UUID      NOT NULL REFERENCES _user (id),
);

CREATE TABLE environment
(
    id         UUID PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    project_id UUID      NOT NULL REFERENCES project (id),
    owner_id   UUID REFERENCES _user (id),
);

CREATE TABLE environment_deployment -- store environment deployments
(
    id             UUID PRIMARY KEY,
    created_at     TIMESTAMP NOT NULL DEFAULT now(),
    environment_id UUID      NOT NULL REFERENCES environment (id),
    owner_id       UUID REFERENCES _user (id),
);

CREATE TABLE environment_event -- store environment events
(
    id             UUID PRIMARY KEY,
    created_at     TIMESTAMP NOT NULL DEFAULT now(),
    environment_id UUID      NOT NULL REFERENCES environment (id),
    owner_id       UUID REFERENCES _user (id),
);

CREATE TABLE application
(
    id             UUID PRIMARY KEY,
    created_at     TIMESTAMP NOT NULL DEFAULT now(),
    environment_id UUID      NOT NULL REFERENCES environment (id),
    owner_id       UUID REFERENCES _user (id),
);

CREATE TABLE application_deployment -- store app deployments
(
    id             UUID PRIMARY KEY,
    created_at     TIMESTAMP NOT NULL DEFAULT now(),
    application_id UUID      NOT NULL REFERENCES application (id),
    owner_id       UUID REFERENCES _user (id),
);

CREATE TABLE application_event -- store app events
(
    id             UUID PRIMARY KEY,
    created_at     TIMESTAMP NOT NULL DEFAULT now(),
    application_id UUID      NOT NULL REFERENCES application (id),
    owner_id       UUID REFERENCES _user (id),
);

CREATE TABLE _database
(
    id             UUID PRIMARY KEY,
    created_at     TIMESTAMP NOT NULL DEFAULT now(),
    environment_id UUID      NOT NULL REFERENCES environment (id),
    owner_id       UUID REFERENCES _user (id),
);

CREATE TABLE database_deployment -- store database deployments
(
    id          UUID PRIMARY KEY,
    created_at  TIMESTAMP NOT NULL DEFAULT now(),
    database_id UUID      NOT NULL REFERENCES _database (id),
    owner_id    UUID REFERENCES _user (id),
);

CREATE TABLE database_event -- store database events
(
    id          UUID PRIMARY KEY,
    created_at  TIMESTAMP NOT NULL DEFAULT now(),
    database_id UUID      NOT NULL REFERENCES _database (id),
    owner_id    UUID REFERENCES _user (id),
);
```

## Application

### list applications

GET /environment/:id/application

> This is partial info to add to the application

```json
{
  "results": [
    {
      "flags": [
        "GIT_CONNECTION_ERROR",
        "UPDATE_AVAILABLE",
        "XXX"
      ]
    }
  ]
}
```

### get application instant metrics on scale and running instances

GET /application/:id/currentScale

```json
{
  "min": 0,
  "max": 8,
  "running": 3,
  "running_in_percent": 37.5,
  "warning_threshold_in_percent": 80,
  "alert_threshold_in_percent": 90,
  "status": {
    "state": "OK|WARNING|ERROR",
    "simple_state": "OK|WARNING|ERROR",
    "message(nullable)": "can be null"
  }
}
```

GET /application/:id/currentInstance

```json
{
  "results": [
    {
      "instance_id": "uuid",
      "cpu": {
        "requested_in_float": 4.0,
        "consumed_in_float": 2.4,
        "consumed_in_percent": 60.0,
        "warning_threshold_in_percent": 80,
        "alert_threshold_in_percent": 95,
        "status": {
          "state": "OK|WARNING|ERROR",
          "simple_state": "OK|WARNING|ERROR",
          "message(nullable)": "can be null"
        }
      },
      "memory": {
        "requested_in_mb": 4096,
        "consumed_in_mb": 3255,
        "consumed_in_percent": 79.6,
        "warning_threshold_in_percent": 80,
        "alert_threshold_in_percent": 95,
        "status": {
          "state": "OK|WARNING|ERROR",
          "simple_state": "OK|WARNING|ERROR",
          "message(nullable)": "can be null"
        }
      },
      "storage(nullable)": {
        "requested_in_gb": 20,
        "consumed_in_gb": 8,
        "consumed_in_percent": 40.0,
        "warning_threshold_in_percent": 80,
        "alert_threshold_in_percent": 90,
        "status": {
          "state": "OK|WARNING|ERROR",
          "simple_state": "OK|WARNING|ERROR",
          "message(nullable)": "can be null"
        }
      }
    }
  ]
}
```

### get application metrics over time

#### CPU metrics

GET /application/:id/metric/cpu?lastDays=30

```json
{
  "results": [
    {
      "instance_name": "instance 1",
      "data": [
        {
          "created_at": "2021-03-20T09:01:28.103Z",
          "value": 2.3
        }
      ]
    },
    {
      "instance_name": "instance 2",
      "data": [
        {
          "created_at": "2021-03-20T09:01:28.103Z",
          "value": 0.8
        }
      ]
    }
  ]
}
```

same for:

* GET /application/:id/metric/memory?lastDays=30
* GET /application/:id/metric/healthCheck?lastDays=30
* GET /application/:id/metric/storage?lastDays=30
* GET /application/:id/metric/instance?lastDays=30

### get current application status

GET /application/:id/status

```json
{
  "status": {
    "state": "BUILDING_ERROR",
    "simple_state": "OK|WARNING|ERROR",
    "message": "Java.xxxx.yyyy not found"
  }
}
```

### get current application logs

#### list last 20 logs

GET /application/:id/log

#### list last 50 logs

GET /application/:id/log?tail=50

```json
{
  "page": 1,
  "page_size": 20,
  "total": 100,
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "DEPLOYING|...",
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "commit": {
        "short_id": "string",
        "long_id": "string",
        "message": "fix: xxxxxxxxxxx"
      },
      "message(nullable)": "log message",
      "message_human_explanation(nullable)": "explain what the error means -- Markdown can be injected",
      "hint(nullable)": "give a possible action to the user -- Markdown can be injected"
    }
  ]
}
```

#### list last logs from lastId

GET /application/:id/log?lastId=xxx

```json
{
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "DEPLOYING|...",
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "message(nullable)": "log message",
      "message_human_explanation(nullable)": "explain what the error means -- Markdown can be injected",
      "hint(nullable)": "give a possible action to the user -- Markdown can be injected"
    }
  ]
}
```

### get application events

#### list last 20 events

GET /application/:id/event

#### list last 50 events

GET /application/:id/event?tail=50

```json
{
  "page": 1,
  "page_size": 20,
  "total": 100,
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "OK|WARNING|ERROR",
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "service": {
        "type": "APPLICATION",
        "id": "uuid",
        "name": "string"
      },
      "commit(nullable)": {
        "short_id": "string",
        "long_id": "string",
        "message": "fix: xxxxxxxxxxx"
      }
    }
  ]
}
```

#### list last events from the lastId

GET /application/:id/event?lastId=xxx

```json
{
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "OK|WARNING|ERROR",
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "service": {
        "type": "APPLICATION",
        "id": "uuid",
        "name": "string"
      },
      "commit(nullable)": {
        "short_id": "string",
        "long_id": "string",
        "message": "fix: xxxxxxxxxxx"
      }
    }
  ]
}
```

### list app deployments

GET /application/:id/deployment?tail=50

```json
{
  "page": 1,
  "page_size": 20,
  "total": 100,
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "DEPLOYMENT_IN_PROGRESS|OK|FAILED",
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "commit(nullable)": {
        "short_id": "string",
        "long_id": "string",
        "message": "fix: xxxxxxxxxxx"
      }
    }
  ]
}
```

#### list last app deployments from the lastId

GET /application/:id/deployment?lastId=xxx

```json
{
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "DEPLOYMENT_IN_PROGRESS|OK|FAILED",
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "commit(nullable)": {
        "short_id": "string",
        "long_id": "string",
        "message": "fix: xxxxxxxxxxx"
      }
    }
  ]
}
```

### rollback a complete environment

POST /environment/:envId/deployment/:id/rollback

### abort deployment task

POST /environment/:envId/deployment/:id/abortDeploy

## Environment variable

### list application environment variables

GET /application/:id/environmentVariable

```json
{
  "results": [
    {
      "id": "uuid",
      "key": "KEY_1",
      "value": "VALUE_1",
      "scope": "BUILT_IN|ORGANIZATION|PROJECT|ENVIRONMENT|APPLICATION"
    }
  ]
}
```

Same for:

* GET /organization/:id/environmentVariable
* GET /project/:id/environmentVariable
* GET /environment/:id/environmentVariable

### create environment variable

POST /application/:id/environmentVariable

```json
{
  "key": "KEY_1",
  "value": "VALUE_1",
  "scope": "ORGANIZATION|PROJECT|ENVIRONMENT|APPLICATION"
}
```

Same for:

* POST /organization/:id/environmentVariable
* POST /project/:id/environmentVariable
* POST /environment/:id/environmentVariable

### delete environment variable

DELETE /environmentVariable/:id

## Secret

### list application secrets

GET /application/:id/secret

```json
{
  "results": [
    {
      "id": "uuid",
      "key": "KEY_1",
      "scope": "BUILT_IN|ORGANIZATION|PROJECT|ENVIRONMENT|APPLICATION",
      "description": "string"
    }
  ]
}
```

Same for:

* GET /organization/:id/secret
* GET /project/:id/secret
* GET /environment/:id/secret

### create secret

POST /application/:id/secret

```json
{
  "key": "KEY_1",
  "value": "VALUE_1",
  "scope": "ORGANIZATION|PROJECT|ENVIRONMENT|APPLICATION",
  "description": "string"
}
```

Same for:

* POST /organization/:id/secret
* POST /project/:id/secret
* POST /environment/:id/secret

### delete environment variable

DELETE /environmentVariable/:id

## Environment

### list environments

GET /project/:id/environment

```json
{
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "updated_at": "2021-03-20T09:01:28.103Z",
      "name": "string",
      "status": {
        "state": "OK|WARNING|ERROR",
        "message(nullable)": "app 1 is down"
      },
      "last_updater": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "cloud_provider": {
        "id": "uuid",
        "name": "Amazon Web Services",
        "short_name": "AWS",
        "logo_url": "https://..."
      },
      "total_services": 18,
      "archived": "false"
    }
  ]
}
```

#### list archived environments

GET /project/:id/environment?archived=true

> An archived environment can't be started

```json
{
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "updated_at": "2021-03-20T09:01:28.103Z",
      "name": "string",
      "status": {
        "state": "OK|WARNING|ERROR",
        "simple_state": "OK|WARNING|ERROR",
        "message(nullable)": "app 1 is down"
      },
      "last_updater": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "cloud_provider": {
        "name": "Amazon Web Services",
        "short_name": "AWS",
        "logo_url": "https://..."
      },
      "total_services": 18,
      "archived": "true"
    }
  ]
}
```

### clone environment

POST /environment/:id/clone

```json
{
  "name": "new env name",
  "mode": "DEVELOPMENT"
}
```

### get environment events

#### list last 20 events

GET /environment/:id/event

#### list last 50 events

GET /environment/:id/event?tail=50

```json
{
  "page": 1,
  "page_size": 20,
  "total": 100,
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "OK|WARNING|ERROR",
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "service": {
        "type": "APPLICATION|DATABASE|JOB|EXTERNAL_SERVICE",
        "id": "uuid",
        "name": "string"
      },
      "commit(nullable)": {
        "short_id": "string",
        "long_id": "string",
        "message": "fix: xxxxxxxxxxx"
      }
    }
  ]
}
```

#### list last events from the lastId

GET /environment/:id/event?lastId=xxx

```json
{
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "OK|WARNING|ERROR",
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "service": {
        "type": "APPLICATION|DATABASE|JOB|EXTERNAL_SERVICE",
        "id": "uuid",
        "name": "string"
      },
      "commit(nullable)": {
        "short_id": "string",
        "long_id": "string",
        "message": "fix: xxxxxxxxxxx"
      }
    }
  ]
}
```

## Deployment

### list environment deployments

GET /environment/:id/deployment?tail=50

```json
{
  "page": 1,
  "page_size": 20,
  "total": 100,
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "DEPLOYMENT_IN_PROGRESS|OK|FAILED",
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "commit(nullable)": {
        "short_id": "string",
        "long_id": "string",
        "message": "fix: xxxxxxxxxxx"
      }
    }
  ]
}
```

#### list last environment deployments from the lastId

GET /environment/:id/deployment?lastId=xxx

```json
{
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "DEPLOYMENT_IN_PROGRESS|OK|FAILED",
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "commit(nullable)": {
        "short_id": "string",
        "long_id": "string",
        "message": "fix: xxxxxxxxxxx"
      }
    }
  ]
}
```

### rollback a complete environment

POST /environment/:envId/deployment/:id/rollback

### abort environment deployment task

POST /environment/:envId/deployment/:id/abortDeploy

## Billing module

The billing module manage:

2. the cost
3. the billing
4. the invoices

### Get current cost

GET /organization/:orgId/currentCost

```json
{
  "plan": "COMMUNITY",
  "remaining_trial_day": 14,
  "remaining_credit": {
    "total_in_cents": 0,
    "total": 0.0,
    "currency_code": "EUR"
  },
  "cost": {
    "total_in_cents": 300000,
    "total": 300.0,
    "currency_code": "EUR"
  },
  "paid_usage": {
    "max_deployments_per_month": 500,
    "consumed_deployments": 300,
    "remaining_deployments": 200,
    "exceeded_deployments": false,
    "next_renewal": "2021-09-01T00:00:00.000Z",
    "addons": [
      {
        "id": "2093029",
        "slug": "",
        "name": "",
        "description": ""
      }
    ]
  },
  "community_usage": {
    "budget_threshold": {
      "total_in_cents": 350000,
      "total": 350.0,
      "currency_code": "EUR"
    },
    "projects": [
      {
        "id": "string",
        "name": "string",
        "consumed_time_in_seconds": 3600,
        "cost": {
          "total_in_cents": 108,
          "total": 1.08,
          "currency_code": "EUR"
        },
        "environments": [
          {
            "id": "string",
            "name": "string",
            "consumed_time_in_seconds": 3600,
            "cost": {
              "total_in_cents": 108,
              "total": 1.08,
              "currency_code": "EUR"
            }
          }
        ]
      }
    ]
  }
}
```

### Get budget threshold

GET /organization/:orgId/costBudget

```json
{
  "total_in_cents": 350000,
  "total": 350.0,
  "currency_code": "EUR"
}
```

### Change budget threshold

PUT /organization/:orgId/costBudget

```json
{
  "total_in_cents": 350000
}
```

### Get billing info

GET /organization/:orgId/billingInfo

```json
{
  "first_name": "string",
  "last_name": "string",
  "email": "string",
  "address": "string",
  "city": "string",
  "zip": "string",
  "state": "string",
  "country_code": "string",
  "company": "string",
  "vat_number": "string"
}
```

### Update billing info

PUT /organization/:orgId/billingInfo

```json
{
  "first_name": "string",
  "last_name": "string",
  "email": "string",
  "address": "string",
  "city": "string",
  "zip": "string",
  "state": "string",
  "country_code": "string",
  "company": "string",
  "vat_number": "string"
}
```

### List invoices

GET /organization/:orgId/invoice

```json
{
  "results": [
    {
      "id": "string",
      "date": "date",
      "status": "PAID|POSTED|PAYMENT_DUE|NOT_PAID|VOIDED|PENDING|UNKNOWN",
      "total_in_cents": 10000,
      "total": 100.0,
      "currency_code": "EUR"
    }
  ]
}
```

statuses

```text
PAID // Indicates a paid invoice.
POSTED // Indicates the payment is not yet collected and will be in this state till the due date to indicate the due period.
PAYMENT_DUE // Indicates the payment is not yet collected and is being retried as per retry settings.
NOT_PAID // Indicates the payment is not made and all attempts to collect is failed.
VOIDED // Indicates a voided invoice.
PENDING // Indicates the invoice is not closed yet. New line items can be added when the invoice is in this state.
UNKNOWN
```

### Get PDF invoice link

GET /invoice/:invoiceId/download

```json
{
  "url": "link_to_pdf"
}
```

### Download all invoices

POST /organization/:organizationId/downloadInvoices

status response 202 -> send email with an attachment containing all invoices

### List credit cards

GET /organization/:organizationId/creditCard

```json
{
  "results": [
    {
      "id": "string",
      "expiry_month": 1,
      "expiry_year": 2023,
      "last_digit": "5487",
      "is_expired": false
    }
  ]
}
```

### Add credit card

POST /organization/:organizationId/creditCard

```json
{
  "number": "string",
  "cvv": "string",
  "expiry_month": 1,
  "expiry_year": 2023
}
```

### Delete credit card

DELETE /creditCard/:creditCardId

status code 204

### Get cluster cost

GET /cluster/:clusterId/currentCost

```json
{
  "total_in_cents": 350000,
  "total": 350.0,
  "currency_code": "EUR"
}
```

### Add credit code

POST /organization/:orgId/creditCode

```json
{
  "code": "string"
}
```

## Referral and rewards

Get referral information

GET /referral

```json
{
  "total_invited": 0,
  "invitation_link": "https://join.qovery.com/xDowkWEl"
}
```

## Addon module

GET /project/:projectId/addon

```json
{
  "results": [
    {
      "name": "Slack",
      "short_description": "string",
      "description": "string",
      "is_trusted": true,
      "is_installed": false,
      "matching_environments_regex": "^feat/.*",
      "metadata": {
      },
      "settings": {
        "api_key": "string"
      }
    }
  ]
}
```

## Organization member

GET /organization/:id/member

```json
{
  "results": [
    {
      "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
      "first_name": "string",
      "last_name": "string",
      "email": "user@example.com",
      "profile_picture_url": "http://example.com",
      "last_activity_at": "2019-08-24T14:15:22Z",
      "role": "OWNER",
      "invitation_status": "PENDING",
      "created_at": "2019-08-24T14:15:22Z",
      "updated_at": "2019-08-24T14:15:22Z"
    }
  ]
}
```

POST /organization/:id/transferOwnership

```json
{
  "user_id": "UUID"
}
```

POST /organization/:id/inviteMember

```json
{
  "email": "string",
  "role": "ADMIN|DEVELOPER|VIEWER"
}
```

response

```json
{
  "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
  "email": "user@example.com",
  "invitation_link": "string",
  "role": "ADMIN|DEVELOPER|VIEWER",
  "invitation_status": "PENDING",
  "created_at": "2019-08-24T14:15:22Z"
}
```

DELETE /organization/:id/member/:userId

DELETE /organization/:id/inviteMember/:userId


