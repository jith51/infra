export type GraphQLFieldErrors = Record<string, string[]>

export type GraphQLApiError = {
  message: string
  path?: string[]
  extensions?: {
    code?: string
    field_errors?: GraphQLFieldErrors
  }
}
