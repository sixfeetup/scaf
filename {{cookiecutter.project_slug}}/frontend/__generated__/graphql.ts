/* eslint-disable */
import { TypedDocumentNode as DocumentNode } from '@graphql-typed-document-node/core';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type MakeEmpty<T extends { [key: string]: unknown }, K extends keyof T> = { [_ in K]?: never };
export type Incremental<T> = T | { [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string; }
  String: { input: string; output: string; }
  Boolean: { input: boolean; output: boolean; }
  Int: { input: number; output: number; }
  Float: { input: number; output: number; }
};

export type OperationInfo = {
  __typename?: 'OperationInfo';
  /** List of messages returned by the operation. */
  messages: Array<OperationMessage>;
};

export type OperationMessage = {
  __typename?: 'OperationMessage';
  /** The error code, or `null` if no error code was set. */
  code?: Maybe<Scalars['String']['output']>;
  /** The field that caused the error, or `null` if it isn't associated with any particular field. */
  field?: Maybe<Scalars['String']['output']>;
  /** The kind of this message. */
  kind: OperationMessageKind;
  /** The error message. */
  message: Scalars['String']['output'];
};

export enum OperationMessageKind {
  Error = 'ERROR',
  Info = 'INFO',
  Permission = 'PERMISSION',
  Validation = 'VALIDATION',
  Warning = 'WARNING'
}

export type RegisterPayload = OperationInfo | UserType;

export type UpdateUserPayload = OperationInfo | UserType;

export type UserMutation = {
  __typename?: 'UserMutation';
  login: UserType;
  logout: Scalars['Boolean']['output'];
  register: RegisterPayload;
  updateUser: UpdateUserPayload;
};


export type UserMutationLoginArgs = {
  password: Scalars['String']['input'];
  username: Scalars['String']['input'];
};


export type UserMutationRegisterArgs = {
  input: UserRegistrationInput;
};


export type UserMutationUpdateUserArgs = {
  input: UserPartialUpdateInput;
};

/** User(id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined, name) */
export type UserPartialUpdateInput = {
  id?: InputMaybe<Scalars['ID']['input']>;
  name?: InputMaybe<Scalars['String']['input']>;
};

export type UserQuery = {
  __typename?: 'UserQuery';
  me: UserType;
};

/** User(id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined, name) */
export type UserRegistrationInput = {
  password: Scalars['String']['input'];
  /** Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only. */
  username: Scalars['String']['input'];
};

/** User(id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined, name) */
export type UserType = {
  __typename?: 'UserType';
  email: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  /** Designates whether this user should be treated as active. Unselect this instead of deleting accounts. */
  isActive: Scalars['Boolean']['output'];
  /** Designates whether the user can log into this admin site. */
  isStaff: Scalars['Boolean']['output'];
  name: Scalars['String']['output'];
  /** Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only. */
  username: Scalars['String']['output'];
};

export type MeQueryVariables = Exact<{ [key: string]: never; }>;


export type MeQuery = { __typename?: 'UserQuery', me: { __typename?: 'UserType', id: string, name: string } };


export const MeDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"Me"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"me"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}}]}}]}}]} as unknown as DocumentNode<MeQuery, MeQueryVariables>;