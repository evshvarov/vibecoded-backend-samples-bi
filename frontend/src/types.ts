export type Product = {
  SKU: string;
  Name: string;
  Category?: string;
  Price?: number;
};

export type Outlet = {
  OutletId: number;
  City: string;
  Country?: string;
  Type?: string;
};

export type SalesItem = {
  SKU: string;
  Name?: string;
  TotalSales: number;
  UnitsSold?: number;
};

export type SalesSummary = {
  TotalSales: number;
  UnitsSold: number;
  Items: SalesItem[];
};

export type ApiError = {
  status: number;
  message: string;
};
