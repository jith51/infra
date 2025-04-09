import { parse, stringify } from 'flatted';

export function omitTypename(operation) {

    const omitTypeName = (key, value) => (key === '__typename' ? undefined : value);

    let variables = operation.variables;

    if ((operation.variables && !operation.getContext().hasUpload)) {
      variables = parse(stringify(operation.variables), omitTypeName);
    }
    
    //borrow from https://gist.github.com/Billy-/d94b65998501736bfe6521eadc1ab538
    const isFile = value => (
        (typeof File !== 'undefined' && value instanceof File) ||
        (typeof Blob !== 'undefined' && value instanceof Blob)
    )
    
    function omitDeep(value, key) {
        if (Array.isArray(value)) {
            return value.map((i) => omitDeep(i, key))
        } else if (typeof value === 'object' && value !== null && !isFile(value)) {      
            return Object.keys(value).reduce((newObject, k) => {
                if (k == key) return newObject
                return Object.assign({ [k]: omitDeep(value[k], key) }, newObject)
            }, {})
        }
        return value
    }

    if (variables) {
        variables = omitDeep(variables, '__typename')
    }

    return variables
}