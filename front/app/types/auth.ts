export type User = {
    id: string
}

export type IUser = User & {
    __typename: string;
}

export type CheckAuthResponse = {
    checkAuth: {
        token: string
        user: IUser
    }
}

export type LogInResponse = {
    userCasLogin: {
        token: string
        user: IUser
    }
}
