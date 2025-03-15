# GA4 Ecom Custom Object from Stape Shopify App DataLayer

## Overview

This template variable would transform the Stape Shopify App ecommerce data layer into a Custom Object.

## Example use case

- Drop unsupported parameters from the GA4 payload like `item_sku`, `imageURL` etc
- Combines variant information (`item_variant` + `variant_name` => Enriched `item_variant`)

## Example Inputs and Outputs

### Purchase Event

#### Input (Stape Format)

```javascript
{
  "event": "purchase_stape",
  "ecommerce": {
    "value": "7630",
    "cart_total": "7630",
    "currency": "LKR",
    "cart_quantity": 1,
    "tax": 0,
    "shipping": 30,
    "transaction_id": "5547159945316",
    "sub_total": 7600,
    "coupon": "SummerSale",
    "items": [
      {
        "item_id": "8003170664548",
        "item_sku": null,
        "item_variant": "45236998537316",
        "item_name": "Example T-Shirt",
        "variant_name": "Lithograph - Height: 9\" x Width: 12\"",
        "item_category": "Shirts",
        "item_brand": "Acme",
        "price": 7600,
        "imageURL": "https://cdn.shopify.com/s/files/1/0693/7693/3988/files/green-t-shirt_64x64.jpg?v=1738978682",
        "discount": null,
        "quantity": 1
      }
    ]
  }
}
```

#### Output

```javascript
{
  "currency": "LKR",
  "value": "7630",
  "transaction_id": "5547159945316",
  "tax": 0,
  "shipping": 30,
  "coupon": "SummerSale",
  // cart_total, cart_quantity, and sub_total are dropped as they're not standard GA4 parameters
  "items": [
    {
      "item_id": "8003170664548",
      "item_name": "Example T-Shirt",
      "item_variant": "45236998537316 - Lithograph - Height: 9\" x Width: 12\"", // Concatenated item_variant + variant_name
      "item_category": "Shirts",
      "item_brand": "Acme",
      "price": 7600,
      "quantity": 1
      // item_sku, imageURL, item_url, discount are dropped as they're not standard GA4 parameters
    }
  ]

}
```

### View Item Event

#### Input (Stape Format)

```javascript
{
  "event": "view_item_stape",
  "ecommerce": {
    "value": "7600",
    "currency": "LKR",
    "items": [
      {
        "item_id": "8003170664548",
        "item_sku": null,
        "item_variant": "45236998537316",
        "item_name": "Example T-Shirt",
        "variant_name": "Lithograph - Height: 9\" x Width: 12\"",
        "item_category": "Shirts",
        "price": 7600,
        "item_brand": "Acme",
        "imageURL": "//cc-gtm.myshopify.com/cdn/shop/files/green-t-shirt.jpg?v=1738978682",
        "item_url": "/products/example-t-shirt",
        "quantity": "1"
      }
    ]
  }
}
```

#### Output (GA4 Format)

```javascript
{
  "currency": "LKR",
  "value": "7600",
  "items": [
    {
      "item_id": "8003170664548",
      "item_name": "Example T-Shirt",
      "item_variant": "45236998537316 - Lithograph - Height: 9\" x Width: 12\"", // Concatenated item_variant + variant_name
      "item_category": "Shirts",
      "item_brand": "Acme",
      "price": 7600,
      "quantity": 1
      // item_sku, imageURL, item_url are dropped as they're not standard GA4 parameters
    }
  ]
}
```
