export interface ICredentials {
  access_token: string;
  client: string;
  uid: string;
  expiry: string;
}

export interface IUser {
  credentials: ICredentials
}

export interface GenericResponse {
  status: string;
  message: string;
}

export interface ILoginInput {
  email: string;
  password: string;
}

export interface ISignUpInput {
  name: string;
  email: string;
  password: string;
  passwordConfirm: string;
}

export interface ILoginResponse {
  status: string;
  access_token: string;
  client: string;
  uid: string;
  expiry: string;
}

export interface ISignUpResponse {
  status: string;
  message: string;
}

export interface IUserResponse {
  status: string;
  data: {
    user: IUser;
  };
}

