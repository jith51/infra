import { CombinedGraphQLErrors } from "@apollo/client/errors";

export interface Callbacks<T> {
  onDone?: (data: T) => void
  onError?: (error: Error) => void
}
export const useDefaultQlCallback = <T>(): Callbacks<T> => ({
  onDone(value: T) {
    console.log(value)
  },
  onError(error: Error) {
    if (CombinedGraphQLErrors.is(error)) {
      console.error(error.errors)
    }
  },
})