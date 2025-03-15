___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "categories": [
    "UTILITY",
    "TAG_MANAGEMENT"
  ],
  "version": 1,
  "securityGroups": [],
  "displayName": "GA4 Ecom Custom Object from Stape Shopify App DataLayer",
  "description": "This template variable would transform the Stape Shopify App ecommerce data layer into a Custom Object (ex use-cases: drop unsupported params from GA4 payload, concat variant_name with item_variant).",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// API
const dataLayer = require('copyFromDataLayer');
const ecommerceData = dataLayer('ecommerce', 1);

// Handle case where ecommerce data doesn't exist
if (!ecommerceData) return {};

// Get items array
var items = ecommerceData.items || [];
var currency = ecommerceData.currency;
var value = ecommerceData.value;
var transaction_id = ecommerceData.transaction_id;
var tax = ecommerceData.tax;
var shipping = ecommerceData.shipping;
var coupon = ecommerceData.coupon;

// Transform items to GA4 format
var itemsArr = [];
if (items && items.length > 0) {
  for (var i = 0; i < items.length; i++) {
    var item = items[i];
    var itemVariant = item.item_variant;
    
    // Combine variant information if variant_name exists
    if (item.variant_name) {
      itemVariant = item.item_variant + ' - ' + item.variant_name;
    }
    
    var transformedItem = {
      item_name: item.item_name,
      item_id: item.item_id,
      price: item.price,
      item_variant: itemVariant,
      quantity: item.quantity || 1
    };
    
    // Add optional fields only if they exist
    if (item.item_category) transformedItem.item_category = item.item_category;
    if (item.item_brand) transformedItem.item_brand = item.item_brand;
    
    itemsArr.push(transformedItem);
  }
}

// Build the final GA4 object
var Obj = {
  currency: currency || undefined,
  items: itemsArr
};

// Add transaction-specific fields if they exist
if (value !== undefined) Obj.value = value;
if (transaction_id) Obj.transaction_id = transaction_id;
if (tax !== undefined) Obj.tax = tax;
if (shipping !== undefined) Obj.shipping = shipping;
if (coupon) Obj.coupon = coupon;

return Obj;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedKeys",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "ecommerce.*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Author: Praba Ponnambalam (praba@measureschool.com)

Releases
********

v1.0 - 2025 March 15


