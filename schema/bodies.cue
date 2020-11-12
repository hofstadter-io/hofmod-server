package schema

import (
	hof "github.com/hofstadter-io/hof/schema"
)

#DefaultCreateOwnBody: {
	M: hof.#Model
	Body: """
	user := c.Get("user").(*dm.User)

	input.UserID = user.ID
	result := db.DB.Create(input)

	if result.Error != nil {
		return result.Error
	}

	return c.JSON(http.StatusOK, input)
	"""
}

#DefaultUpdateOwnBody: {
	M: hof.#Model
	Body: """
	user := c.Get("user").(*dm.User)

	ID, err := uuid.Parse(id)
	if err != nil {
		return err
	}
	input.ID = ID
	input.UserID = user.ID

	result := db.DB.Model(&dm.\(M.ModelName){}).Where("user_id = ? AND id = ?", user.ID.String(), id).Updates(input)

	if result.Error != nil {
		return result.Error
	}

	return c.JSON(http.StatusOK, input)
	"""
}

#DefaultDeleteOwnBody: {
	M: hof.#Model
	Body: """
	user := c.Get("user").(*dm.User)

	ID, err := uuid.Parse(id)
	if err != nil {
		return err
	}

	result := db.DB.Where("user_id = ?", user.ID.String()).Delete(&dm.\(M.ModelName){}, ID)
	if result.Error != nil {
		return result.Error
	}

	return c.NoContent(http.StatusOK)
	"""
}

#DefaultListOwnBody: {
	M: hof.#Model
	Body: """
	user := c.Get("user").(*dm.User)

	var data []dm.\(M.ModelName)
	tx := db.DB.Model(&dm.\(M.ModelName){}).Where("user_id = ?", user.ID.String())
	if offset != "" {
		O, err := strconv.Atoi(offset)
		if err != nil || O < 0{
			return c.String(http.StatusBadRequest, "offset is not a valid, non-negative number")
		}
		tx.Offset(O)
	}
	if limit != "" {
		L, err := strconv.Atoi(limit)
		if err != nil || L < 0 {
			return c.String(http.StatusBadRequest, "limit is not a valid, non-negative number")
		}
		tx.Limit(L)
	}
	
	err = tx.Find(&data).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return c.NoContent(http.StatusOK)
		}
		return err
	}

	return c.JSON(http.StatusOK, data)
	"""
}

#DefaultGetOwnBody: {
	M: hof.#Model
	Body: """
	user := c.Get("user").(*dm.User)
	var data dm.\(M.ModelName)
	tx := db.DB.Model(&dm.\(M.ModelName){}).Where("user_id = ? AND id = ?", user.ID.String(), id)
	err = tx.First(&data).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return c.NoContent(http.StatusOK)
		}
		return err
	}


	if data.ID == uuid.Nil {
		return c.NoContent(http.StatusOK)
	}

	return c.JSON(http.StatusOK, data)
	"""
}
