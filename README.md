# Fitting

<img align="right" width="192" height="192"
alt="Fitting avatar: Documents with hangers"
src="./images/logo.png">

We set up test logs, validate them according to your API documentation and show the documentation coverage with logs.

Test logs setting supports RSpec test (and WebMock stubbing) for Ruby On Rails application and API documentation supports API Blueprint,
Swagger and OpenAPI.

This reduces the costs of support, testers and analysts.

Log
```text
FITTING incoming request {"method":"POST","path":"/public/api/v1/inboxes/tEX5JiZyceiwuKMi1oN9Sf8S/contacts","body":{},"response":{"status":200,"content_type":"application/json","body":{"source_id":"00dbf18d-879e-47cb-ac45-e9aece266eb1","pubsub_token":"ktn6YwPus57JDf4e59eFPom5","id":3291,"name":"shy-surf-401","email":null,"phone_number":null}},"title":"./spec/controllers/public/api/v1/inbox/contacts_controller_spec.rb:9","group":"./spec/controllers/public/api/v1/inbox/contacts_controller_spec.rb","host":"www.example.com"}
FITTING outgoing request {"method":"POST","path":"/v1/organizations/org_id/meeting","body":{},"response":{"status":200,"content_type":"application/json","body":{"success":true,"data":{"meeting":{"id":"meeting_id","roomName":"room_name"}}}},"title":"./spec/controllers/api/v1/accounts/integrations/dyte_controller_spec.rb:50","group":"./spec/controllers/api/v1/accounts/integrations/dyte_controller_spec.rb","host":"api.cluster.dyte.in"}
```

validation
```console
..*.....F.

  1) Fitting::Doc::NotFound log error:

host: www.example.com
method: POST
path: /public/api/v1/inboxes/{inbox_identifier}/contacts
code: 200

content-type: application/json

json-schema: {
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "properties": {
    "id": {
      "type": "integer",
      "description": "Id of the contact"
    },
    "source_id": {
      "type": "string",
      "description": "The session identifier of the contact"
    },
    "name": {
      "type": "string",
      "description": "Name of the contact"
    },
    "email": {
      "type": "string",
      "description": "Email of the contact"
    },
    "pubsub_token": {
      "type": "string",
      "description": "The token to be used to connect to chatwoot websocket"
    }
  }
}

body: {
  "source_id": "c9e8c31f-06df-49b4-8fb9-4466457ae65b",
  "pubsub_token": "Zgc7DEvaj5TkgZ1a4C7AvJXo",
  "id": 3293,
  "name": "restless-snowflake-670",
  "email": null,
  "phone_number": null
}

error [
  "The property '#/email' of type null did not match the following type: string in schema e56b7e65-d70c-5f7a-a96c-982df5f8f2f7"
]


10 examples, 1 failure, 1 pending

Coverage 90%
```

and cover
![exmaple](images/b1.png)

![exmaple](images/b2.png)

![exmaple](images/w1.png)

![exmaple](images/w2.png)

## Installation
Add this line to your application's Gemfile:
```ruby
gem 'fitting'
```

After that execute:
```bash
$ bundle
```

Or install the gem by yourself:
```bash
$ gem install fitting
```

## Usage
### Log
Firstly, improve `test.log`.

To your `spec_helper.rb`:

```ruby
require 'fitting'

Fitting.logger
```

Delete all files `log/*.log` and run rspec

You get more information about incoming and outgoing request in `log/fitting*.log`.

```text
FITTING incoming request {"method":"POST","path":"/api/v1/profile",
"body":{"ids":[]},"response":{"status":200,"body":{"status":"unauthorized"}},
"title":"./spec/support/shared_examples/unauthorized.rb:8","group":"./spec/support/shared_examples/unauthorized.rb"}
FITTING outgoing request {"method":"POST",
"path":"/sso/oauth2/access_token","body":{},"response":{"status":404,"body":{
"error":"Not found","error_description":"any error_description"}},"title":"./spec/jobs/sso_create_link_job_spec.rb:93",
"group":"./spec/jobs/sso_create_link_job_spec.rb"}
```

### Validation
Secondly, validate the logs to the documentation.

Add this to your `.fitting.yml`:

```yaml
APIs:
  - host: www.example.com
    type: openapi2
    path: swagger/swagger.json
```

Run 
```bash
bundle e rake fitting:report
```

Console output

```console
..*.....F.

  1) Fitting::Report::Responses::NotFound method: GET, host: books.local, path: /api/v1/users, status: 200,
  body: {"name"=>"test"}


body: {"$schema"=>"http://json-schema.org/draft-04/schema#", "type"=>"enum"}
validate: ["The property '#/' did not contain a required property of 'test' in schema
5115a024-5312-540f-8666-3102097d8c17"]

status: 401

status: 500


10 examples, 1 failure, 1 pending

Coverage 90%
```

### Coverage
And task will create HTML (`coverage/fitting.html`) reports.

![exmaple](images/b1.png)

![exmaple](images/w1.png)

More information on action coverage

![exmaple2](images/b2.png)

![exmaple2](images/w2.png)

## type

### OpenAPI 2.0
Also Swagger

```yaml
prefixes:
  - name: /api/v1
    type: openapi2
    schema_paths:
      - doc.json
```

### OpenAPI 3.0
Also OpenAPI

```yaml
prefixes:
  - name: /api/v1
    type: openapi3
    schema_paths:
      - doc.yaml
```

### API Blueprint
First you need to install [drafter](https://github.com/apiaryio/drafter).
Works after conversion from API Blueprint to API Elements (in YAML file) with Drafter.

That is, I mean that you first need to do this

```bash
drafter doc.apib -o doc.yaml
```

and then

```yaml
prefixes:
  - name: /api/v1
    type: drafter
    schema_paths:
      - doc.yaml
```

### Tomograph

To use additional features of the pre-converted [tomograph](https://github.com/funbox/tomograph)

```yaml
prefixes:
  - name: /api/v1
    type: tomogram
    schema_paths:
      - doc.json
```

## prefix name

Setting the prefix name is optional. For example, you can do this:

```yaml
prefixes:
  - type: openapi2
    schema_paths:
      - doc.json
```

## prefix skip

It is not necessary to immediately describe each prefix in detail, you can only specify its name and skip it until you are ready to documented it
```yaml
prefixes:
- name: /api/v1
  type: openapi2
  schema_paths:
    - doc.json
- name: /api/v3
  skip: true
```

For work with WebMock outgoing request, you should set up outgoing prefixes
```yaml
outgoing_prefixes:
- name: /api/v1
  type: openapi2
  schema_paths:
    - doc.json
- name: /api/v3
  skip: true
```

You can choose location that must be teste

```yaml
prefixes:
  - type: openapi2
    schema_paths:
      - doc.json
    only:
      - POST /api/v1/users
      - GET /api/v1/user/{id}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [github.com/funbox/fitting](https://github.com/funbox/fitting).
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[![Sponsored by FunBox](https://funbox.ru/badges/sponsored_by_funbox_centered.svg)](https://funbox.ru)
