killbill-qiwi-plugin
====================

Plugin to use [QIWI](https://qiwi.com/) as a gateway.

Release builds are available on [Maven Central](http://search.maven.org/#search%7Cga%7C1%7Cg%3A%22org.kill-bill.billing.plugin.ruby%22%20AND%20a%3A%22qiwi-plugin%22) with coordinates `org.kill-bill.billing.plugin.ruby:qiwi-plugin`.

Kill Bill compatibility
-----------------------

| Plugin version | Kill Bill version |
| -------------: | ----------------: |
| 0.x.y          | 0.16.z            |

Requirements
------------

The plugin needs a database. The latest version of the schema can be found [here](https://github.com/killbill/killbill-qiwi-plugin/blob/master/db/ddl.sql).

Configuration
-------------

```
curl -v \
     -X POST \
     -u admin:password \
     -H 'X-Killbill-ApiKey: bob' \
     -H 'X-Killbill-ApiSecret: lazar' \
     -H 'X-Killbill-CreatedBy: admin' \
     -H 'Content-Type: text/plain' \
     -d ':qiwi:
  :account_id: "your-account-id"' \
     http://127.0.0.1:8080/1.0/kb/tenants/uploadPluginConfig/killbill-qiwi
```

Usage
-----

Add a default payment method:

```
curl -v \
     -X POST \
     -u admin:password \
     -H 'X-Killbill-ApiKey: bob' \
     -H 'X-Killbill-ApiSecret: lazar' \
     -H 'X-Killbill-CreatedBy: admin' \
     -H 'Content-Type: application/json' \
     -d '{
       "pluginName": "killbill-qiwi",
       "pluginInfo": {
         "properties": []
       }
     }' \
     "http://127.0.0.1:8080/1.0/kb/accounts/<ACCOUNT_ID>/paymentMethods?isDefault=true"
```

Call [buildFormDescriptor](http://docs.killbill.io/0.16/userguide_payment.html#_hosted_payment_page_flow):

```
curl -v \
     -u admin:password \
     -H 'X-Killbill-ApiKey: bob' \
     -H 'X-Killbill-ApiSecret: lazar' \
     -H 'Content-Type: application/json' \
     -H 'X-Killbill-CreatedBy: demo' \
     -X POST \
     --data-binary '{
       "formFields": [
         {
           "key": "order_id",
           "value": "1234"
         },
         {
           "key": "amount",
           "value": "750"
         }
       ]
     }' \
     "http://127.0.0.1:8080/1.0/kb/paymentGateways/hosted/form/<ACCOUNT_ID>"
```

The response will look like:

```
{
  "kbAccountId": "<ACCOUNT_ID>",
  "formMethod": "GET",
  "formUrl": "https://w.qiwi.com/payment/form.action",
  "formFields": {
    "amount": "750",
    "id": "1234",
    "provider": "11223344"
  },
  "properties": {},
  "auditLogs": null
}
```

This indicates that the user should be redirected to https://w.qiwi.com/payment/form.action?amount=750&id=1234&provider=11223344.

Upon success, following the redirect from QIWI, record the payment in Kill Bill:

```
curl -v \
     -X POST \
     -u admin:password \
     -H 'Content-Type: application/json' \
     -H 'X-Killbill-ApiKey:bob' \
     -H 'X-Killbill-ApiSecret:lazar' \
     -H 'X-Killbill-CreatedBy: creator' \
     --data-binary '{"transactionType":"PURCHASE","amount":"750"}' \
     "http://127.0.0.1:8080/1.0/kb/accounts/<ACCOUNT_ID>/payments"
```
