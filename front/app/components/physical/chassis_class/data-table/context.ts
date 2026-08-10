
import type { ChassisClassType, ChassisClassFilterType } from '@/types/physical/chassis_class'
import type { ChassisPowertypeType } from '@/types/physical/chassis_powertype'
import type { Table } from "@tanstack/vue-table"

type ChassisPowertypeWithCount = ChassisPowertypeType & {
  chassisClassesNumber: number;
};

interface ChassisClassesTableContext {
    table: Table<ChassisClassType>,
    filter: Ref<ChassisClassFilterType>,
    chassisPowertypes: Ref<ChassisPowertypeWithCount[]>
}

const ChassisClassesTableContextKey: InjectionKey<ChassisClassesTableContext> = Symbol('ChassisClassesTableContext')

export function provideChassisClassesTableContext(context: ChassisClassesTableContext) {
    provide(ChassisClassesTableContextKey, context)
}

export function useChassisClassesTableContext() {
    const context = inject(ChassisClassesTableContextKey)

    if (!context)
        throw new Error('ChassisClassesTable components must be used inside ChassisClassesTable')

    return context
}
