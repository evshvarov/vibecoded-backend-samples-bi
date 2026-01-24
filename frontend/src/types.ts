export type Product = {
  SKU: string;
  Name: string;
  Category?: string;
  Price?: number;
};

export type ApiError = {
  status: number;
  message: string;
};
