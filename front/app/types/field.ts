import * as v from 'valibot'

export const FIELD_TYPES = [
    // 'checkbox',
    'boolean',
    // 'color',
    'date',
    'ip',
    'email',
    // 'file',
    // 'month',
    'number',
    // 'password',
    // 'radio',
    // 'range',
    // 'reset',
    // 'search',
    'tel',
    'text',
    // 'time',
    'url',
    // 'week' 
] as const

export type FieldType = (typeof FIELD_TYPES)[number];

export const fieldSchema = v.picklist(FIELD_TYPES);

export const validateField = (type: FieldType, value: unknown) => {
    let schema;
    
    switch (type) {
    case "text":
        schema = v.nullish(v.string())
        break;

    case "number":
        schema = v.nullish(v.number())
        break;

    case "boolean":
        schema = v.nullish(v.boolean())
        break;

    case "url":
        schema = v.nullish(v.union([
            v.literal(""),
            v.pipe(v.string(), v.url()),
        ]))
        break;
    
    case "email":
        schema = v.nullish(v.union([
            v.literal(""),
            v.pipe(v.string(), v.email()),
        ]))
        break;

    case "ip":
        schema = v.nullish(v.union([
            v.literal(""),
            v.pipe(v.string(), v.ip()),
        ]))
        break;

    default:
        schema = v.unknown();
    }

    return v.safeParse(schema, value);
}