namespace Infra.Db;

public interface IDbAdapter<TClass, TId> where TClass : class
{
    IList<TClass> GetAll();
    void SetAll(IEnumerable<TClass> all);
    TClass? GetById(TId id);
    void Create(TClass item);
    void Update(TId id, TClass item);
    void Delete(TId id);
    bool Detached { get; set; }
    string DumpSql(IEnumerable<TClass> items);
    
    /// <summary>
    /// Gets entities by a field value using a simple field name and value
    /// </summary>
    /// <param name="fieldName">The name of the field to query (property name, will be converted to snake_case)</param>
    /// <param name="value">The value to search for</param>
    /// <returns>List of entities matching the criteria</returns>
    IList<TClass> GetByField(string fieldName, object value);
    
    /// <summary>
    /// Gets entities by multiple field values
    /// </summary>
    /// <param name="criteria">Dictionary of field names and their values</param>
    /// <returns>List of entities matching all criteria</returns>
    IList<TClass> GetByFields(Dictionary<string, object> criteria);
    
    /// <summary>
    /// Gets entities using a custom WHERE clause
    /// </summary>
    /// <param name="whereClause">The WHERE clause (without the WHERE keyword)</param>
    /// <param name="parameters">Parameters for the WHERE clause</param>
    /// <returns>List of entities matching the criteria</returns>
    IList<TClass> GetByWhere(string whereClause, Dictionary<string, object>? parameters = null);
    
    /// <summary>
    /// Gets a single entity by field value, returns null if not found
    /// </summary>
    /// <param name="fieldName">The name of the field to query</param>
    /// <param name="value">The value to search for</param>
    /// <returns>The first matching entity or null</returns>
    TClass? GetFirstByField(string fieldName, object value);
    
    /// <summary>
    /// Checks if any entity exists with the given field value
    /// </summary>
    /// <param name="fieldName">The name of the field to query</param>
    /// <param name="value">The value to search for</param>
    /// <returns>True if any entity exists with the given field value</returns>
    bool ExistsByField(string fieldName, object value);
}
