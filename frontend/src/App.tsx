import { useEffect, useMemo, useState } from "react";
import {
  createProduct,
  deleteProduct,
  getSpec,
  listProducts,
  updateProduct,
} from "./api";
import type { Product } from "./types";

type FormState = {
  SKU: string;
  Name: string;
  Category: string;
  Price: string;
};

const emptyForm: FormState = {
  SKU: "",
  Name: "",
  Category: "",
  Price: "",
};

export default function App() {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [query, setQuery] = useState("");
  const [createForm, setCreateForm] = useState<FormState>(emptyForm);
  const [editForm, setEditForm] = useState<FormState>(emptyForm);
  const [editingSku, setEditingSku] = useState<string | null>(null);
  const [specOpen, setSpecOpen] = useState(false);
  const [specJson, setSpecJson] = useState<string>("");

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return products;
    return products.filter((item) => {
      return (
        item.SKU.toLowerCase().includes(q) ||
        item.Name.toLowerCase().includes(q) ||
        (item.Category || "").toLowerCase().includes(q)
      );
    });
  }, [products, query]);

  useEffect(() => {
    void reloadProducts();
  }, []);

  async function reloadProducts() {
    setLoading(true);
    setError(null);
    try {
      const data = await listProducts();
      setProducts(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Unable to load products.");
    } finally {
      setLoading(false);
    }
  }

  function parsePrice(value: string) {
    if (value.trim() === "") return undefined;
    const parsed = Number(value);
    return Number.isNaN(parsed) ? undefined : parsed;
  }

  async function handleCreate(event: React.FormEvent) {
    event.preventDefault();
    setError(null);
    const payload: Product = {
      SKU: createForm.SKU.trim(),
      Name: createForm.Name.trim(),
      Category: createForm.Category.trim() || undefined,
      Price: parsePrice(createForm.Price),
    };

    if (!payload.SKU || !payload.Name) {
      setError("SKU and Name are required.");
      return;
    }

    try {
      const created = await createProduct(payload);
      setProducts((prev) => [created, ...prev]);
      setCreateForm(emptyForm);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Unable to create product.");
    }
  }

  function startEdit(product: Product) {
    setEditingSku(product.SKU);
    setEditForm({
      SKU: product.SKU,
      Name: product.Name,
      Category: product.Category || "",
      Price: product.Price?.toString() || "",
    });
  }

  function cancelEdit() {
    setEditingSku(null);
    setEditForm(emptyForm);
  }

  async function handleUpdate(event: React.FormEvent) {
    event.preventDefault();
    if (!editingSku) return;
    setError(null);
    const payload: Product = {
      SKU: editForm.SKU.trim(),
      Name: editForm.Name.trim(),
      Category: editForm.Category.trim() || undefined,
      Price: parsePrice(editForm.Price),
    };

    if (!payload.Name) {
      setError("Name is required.");
      return;
    }

    try {
      const updated = await updateProduct(editingSku, payload);
      setProducts((prev) =>
        prev.map((item) => (item.SKU === editingSku ? updated : item)),
      );
      cancelEdit();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Unable to update product.");
    }
  }

  async function handleDelete(sku: string) {
    setError(null);
    try {
      await deleteProduct(sku);
      setProducts((prev) => prev.filter((item) => item.SKU !== sku));
    } catch (err) {
      setError(err instanceof Error ? err.message : "Unable to delete product.");
    }
  }

  async function handleLoadSpec() {
    setError(null);
    try {
      const spec = await getSpec();
      setSpecJson(JSON.stringify(spec, null, 2));
      setSpecOpen(true);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Unable to fetch spec.");
    }
  }

  return (
    <div className="app">
      <header className="hero">
        <div>
          <p className="eyebrow">HoleFoods API Console</p>
          <h1>Product control with live Swagger wiring.</h1>
          <p className="subhead">
            Manage catalog items, validate new SKUs, and export the API spec in
            one focused workspace.
          </p>
          <div className="hero-actions">
            <button className="primary" onClick={handleLoadSpec}>
              View Spec
            </button>
            <button className="ghost" onClick={reloadProducts}>
              Refresh Products
            </button>
          </div>
        </div>
        <div className="hero-card">
          <div className="stat">
            <span>Inventory Items</span>
            <strong>{products.length}</strong>
          </div>
          <div className="stat">
            <span>Status</span>
            <strong>{loading ? "Syncing" : "Live"}</strong>
          </div>
          <div className="stat">
            <span>Endpoint</span>
            <strong>/holefoods/api</strong>
          </div>
        </div>
      </header>

      <main className="grid">
        <section className="panel">
          <div className="panel-header">
            <div>
              <h2>Create Product</h2>
              <p>Send a POST to /products with a curated payload.</p>
            </div>
          </div>
          <form className="form" onSubmit={handleCreate}>
            <label>
              SKU
              <input
                value={createForm.SKU}
                onChange={(event) =>
                  setCreateForm({ ...createForm, SKU: event.target.value })
                }
                placeholder="SKU-101"
              />
            </label>
            <label>
              Name
              <input
                value={createForm.Name}
                onChange={(event) =>
                  setCreateForm({ ...createForm, Name: event.target.value })
                }
                placeholder="Bagels (dozen)"
              />
            </label>
            <label>
              Category
              <input
                value={createForm.Category}
                onChange={(event) =>
                  setCreateForm({ ...createForm, Category: event.target.value })
                }
                placeholder="Snack"
              />
            </label>
            <label>
              Price
              <input
                value={createForm.Price}
                onChange={(event) =>
                  setCreateForm({ ...createForm, Price: event.target.value })
                }
                placeholder="2.95"
              />
            </label>
            <button className="primary" type="submit">
              Create Product
            </button>
          </form>
        </section>

        <section className="panel">
          <div className="panel-header">
            <div>
              <h2>Catalog</h2>
              <p>Search and edit live inventory in place.</p>
            </div>
            <input
              className="search"
              value={query}
              onChange={(event) => setQuery(event.target.value)}
              placeholder="Search SKU, name, category"
            />
          </div>

          {loading ? (
            <div className="empty">Loading products...</div>
          ) : filtered.length === 0 ? (
            <div className="empty">No products match this query.</div>
          ) : (
            <div className="cards">
              {filtered.map((product) => (
                <article className="card" key={product.SKU}>
                  <div className="card-top">
                    <div>
                      <p className="sku">{product.SKU}</p>
                      <h3>{product.Name}</h3>
                      <p className="meta">
                        {product.Category || "Uncategorized"}
                      </p>
                    </div>
                    <span className="price">
                      {product.Price !== undefined
                        ? `$${product.Price.toFixed(2)}`
                        : "--"}
                    </span>
                  </div>
                  <div className="card-actions">
                    <button className="ghost" onClick={() => startEdit(product)}>
                      Edit
                    </button>
                    <button
                      className="danger"
                      onClick={() => handleDelete(product.SKU)}
                    >
                      Delete
                    </button>
                  </div>
                </article>
              ))}
            </div>
          )}
        </section>
      </main>

      <section className={`drawer ${editingSku ? "open" : ""}`}>
        <div className="drawer-content">
          <div className="drawer-header">
            <div>
              <h2>Edit Product</h2>
              <p>Update fields and push a PUT to /products/{`{sku}`}.</p>
            </div>
            <button className="ghost" onClick={cancelEdit}>
              Close
            </button>
          </div>
          <form className="form" onSubmit={handleUpdate}>
            <label>
              SKU
              <input value={editForm.SKU} disabled />
            </label>
            <label>
              Name
              <input
                value={editForm.Name}
                onChange={(event) =>
                  setEditForm({ ...editForm, Name: event.target.value })
                }
              />
            </label>
            <label>
              Category
              <input
                value={editForm.Category}
                onChange={(event) =>
                  setEditForm({ ...editForm, Category: event.target.value })
                }
              />
            </label>
            <label>
              Price
              <input
                value={editForm.Price}
                onChange={(event) =>
                  setEditForm({ ...editForm, Price: event.target.value })
                }
              />
            </label>
            <div className="drawer-actions">
              <button className="primary" type="submit">
                Save Changes
              </button>
              <button className="ghost" type="button" onClick={cancelEdit}>
                Cancel
              </button>
            </div>
          </form>
        </div>
      </section>

      <section className={`drawer ${specOpen ? "open" : ""}`}>
        <div className="drawer-content spec">
          <div className="drawer-header">
            <div>
              <h2>OpenAPI Spec</h2>
              <p>Fetched from /_spec for quick inspection.</p>
            </div>
            <button className="ghost" onClick={() => setSpecOpen(false)}>
              Close
            </button>
          </div>
          <pre>{specJson || "No spec loaded yet."}</pre>
        </div>
      </section>

      {error ? <div className="toast">{error}</div> : null}
    </div>
  );
}
