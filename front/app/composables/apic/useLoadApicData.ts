
import APIC_QUERY from '~/graphql/apic/apic.query.gql'
import { useQuery } from '@vue/apollo-composable'

export const useLoadApicData = () => {
  const tenants = ref([])
  const contrats = ref([])
  const tasks = ref([])

  const { result } = useQuery(APIC_QUERY)

  watchResult(result, (result) => {
    tenants.value = result.tenants
    contrats.value = result.contrats
    tasks.value = result.tasks
  })

  return { tenants, contrats, tasks }
}